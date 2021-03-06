---
title: "Advanced JSON marshalling in Go"
date:  "2019-06-28"
---

At [Algolia](https://www.algolia.com/), I maintain open-source API clients
that we publish as libraries, to map several JSON REST APIs. We are doing that
for many programming languages but the one I’ve used the most recently
was Go. As library authors, one of your goals is to reduce the number
of dependencies we rely on. This matters for our end users - preventing
dependency conflicts - and for us - reducing the support tickets generated
by such conflicts.  So far, we managed to provide our Go library without
any transitive dependency. To be fair, we have one development dependency
for our tests ([stretchr/testify](https://github.com/stretchr/testify))
and we make extensive use of the standard library.

## Handle legacy fields

Mapping JSON payloads and Go structures is a simple task thanks to the
`encoding/json` package from the standard library. However, it may become
a bit more difficult when payloads and structures do not have this 1:1
mapping anymore. Sometimes, payloads may use multiple names for the same
field. Picture a JSON payload for which an attribute was set according to
a specific name that had to be renamed at some point.

```json
// Legacy payload
{
  "name": "Anthony"
}

// New payload
{
  "firstname": "Anthony",
  "lastname": "Seure"
}
```

In this case, `name` attribute has been renamed into `firstname`. However,
the API may return both payloads depending on whether the data was stored
before or after that change. On Go’ side, the structure which is publicly
exposed to users reflect the new format:

```go
type Contact struct {
    Firstname string `json:"firstname"`
    Lastname  string `json:"lastname"`
}
```

Because we don’t want to expose the legacy `name` attribute name on our Go
public API, we’ll have to write a custom deserialiser for the `Contact`
structure. Luckily for us, we exactly know what the legacy payload looks
like. Let’s use a dedicated, unexpected structure to represent it:

```go
type legacyContact struct {
    Name string `json:"name"`
}
```

Finally, let’s unmarshal our payload into both Go representations and
replace their fields where needed:

```go
func (c *Contact) UnmarshalJSON(data []byte) error {
    var tmp legacyContact

    json.Unmarshal(data, c)
    json.Unmarshal(data, &tmp)

    if len(c.Name) == 0 {
        c.Name = legacy.Field
    }

    return nil
}
```

This clearly has a cost in term of performances so if your code is CPU-bounded,
you may want to reconsider this solution. Otherwise, this remains a concise
(besides the shamelessly omitted error handling) and dependency-free solution.

From a maintenance perspective, this is one of the things I like in Go:
explicit complexity.

## Unmarshal unknown fields

Often times, some payload fields may not need to be reflected on the public API
of the Go structures. When those fields are known, this may be quite easy,
you can use the same trick we’ve just seen: unmarshal to a unexported
structure, with contains all the known fields, in the `UnmarshalJSON()`
function of your exported structure. However, it may become tedious when
those fields are unknown. Even worse: how to expose them publicly? Let’s
take the following JSON payload along with its Go representation:

```json
{
  "name": "Anthony",
  "age": 26
}
```

```go
type Contact struct {
    Name string `json:"name"`
}
```

In that case, the `age` property is unknown from the Go structure’s point of
view. However, it needs to be exposed publicly. Here is the thing: we’ll
now gather all unknown fields in a map that will be publicly exposed:

```go
type Contact struct {
    Name          string                 `json:"name"`
    UnknownFields map[string]interface{} `json:"-"`
}
```

As you may see, two new things here. First, the `UnknownFields` field which
will hold and publicly expose all unknown values from our payload. Map’
keys remain untyped. Note that the public API could be improved by writing
helper functions to ease type conversions but let’s not talk about that for
now. Second, the use of the `-` (dash) JSON tag. As per the [Go documentation
of the `encoding/json`](https://golang.org/pkg/encoding/json/#Marshal) package:

> As a special case, if the field tag is `"-"`, the field is always omitted.
> Note that a field with name `"-"` can still be generated using the tag `"-,"`.

In other words, even though the `UnknownFields` field is exposed, the JSON
library will ignore it entirely.

Perfect! Let’s populate it now. Similarly to what we have done to handle
legacy JSON fields, the trick here is to deserialize two times the payload:
one time in our structure, second time in our map:

```go
func (c *Contact) UnmarshalJSON(data []byte) error {
    type contact Contact

    json.Unmarshal(data, (*contact)(c))
    json.Unmarshal(data, &c.UnknownFields)
    delete(c.UnknownFields, "name")

    return nil
}
```

You may wonder why the `contact` type alias on `Contact` is used. It’s
simply to avoid infinite recursion of deserialisation. If we were to call
`json.Unmarshal` on `c` typed as `*Contact`, our `UnmarshalJSON()` function
will simply be called again… and again… and again… By introducing an
intermediate type alias, recursive calls are completely bypassed: the JSON
library will populate `c` fields as we would expect (i.e. according to the
JSON tags we set).

After the two `json.Unmarshal` calls, all known fields have been correctly
deserialized into our structure. However, both known and unknown fields
are present in the map. Hence the final `delete` call which remove the
known `name` field from our map of unknown fields. This seems tedious and
error-prone but they are different solutions not to forget to call `delete`
on all known fields. First, one can use reflection to extract the field
names of the `Contact` structure and call `delete` for each of them. Another
solution that would prevent from using reflection, is to use `go generate`
to have the delete call generated, based on a list of known fields. This
is the approach we took at my work as we fully generate the structure along
with its `UnmarshalJSON` function anyway.

## Marshal unknown fields

Having a neat public API that only exposes what is needed and documented
for the end user is a utopia.

They are times where your users will want or need to use undocumented
parameters. Where I work, we need to handle that case for advanced features
needed by power-user. Because those features may have degraded performance
when used unwisely, we purportedly do not document them. Still, for those
few users who know and need to use them, we have to offer them a way, through
our public API to let them inject custom fields in our JSON payload. Let’s
take an example here:

```go
type Heating struct {
    Temperature int `json:"temperature"`
}
```

However, let’s suppose our end user need to pass an undocumented but valid
extra field such as the final JSON payload would look like so:

```json
{
  "temperature": 42,
  "force_on": true
}
```

The easy and straightforward solution is to let the user defined their own
type using composition.

```go
type HeatingExtra struct {
    Heating
    ForceOn bool `json:"force_on"`
}
```

While this solution does work, there are two main issues here. First, due to
lack of structural typing in Go, instantiating composed structure is painful:

```go
h := HeatingExtra{
    Heating: Heating{
        Temperature: 21,
    },
    ForceOn: true,
}
```

More importantly, the fact that the user has to create a new dedicated
structure every time a new parameter needs to be added is cumbersome and
also not usable if the entire public API expects `Heating` structures
anyway. The approach to solve this issue is two-fold: first, the
public API needs to be completely agnostic of the extra fields we
may need; second, the internal of the `MarshalJSON()` custom function
we will write will have to handle this non-existing feature from the
standard library. Regarding the public API, one approach is to expose
what Dave Cheney coined as functional options in [his early article from
2017](https://dave.cheney.net/2014/10/17/functional-options-for-friendly-apis).
In our example, it may be implemented as such:

```go
type Heating struct {
    Temperature  int                    `json:"temperature"`
    ExtraOptions map[string]interface{} `json:"-"`
}

type CustomOption struct {
    K string
    V interface{}
}

func NewHeating(t int, opts ...CustomOption) Heating {
    m := make(map[string]interface{})
    for _, opt := range opts {
        m[opt.K] = opt.V
    }
    return Heating{
        Temperature:  t,
        ExtraOptions: m,
    }
}

func (h Heating) MarshalJSON() ([]byte, error) {
    // TODO
}

func main() {
    opt := CustomOption{K: "force_on", V: true}
    h := NewHeating(21, opt)

    data, _ := json.Marshal(h)
    fmt.Println(string(data))
}
```

As you see, from the caller point of view, everything is fairly easy
to use. On the implementer’ side, you know have an easy way to hold
user-defined options that are not known until runtime. Now let’s see how
the magic happens, if any.

The overall implementation of `MarshalJSON()` is pretty straightforward. It
goes as follows:

1. If no `CustomOption` was provided, simply serialize `Heating` and return
2. Otherwise, build a new type, at runtime, containing both fields from our original `Heating` structure…
3. …and new fields based on the provided `CustomOption`s
4. Create a new instance of this type
5. Serialize it

And here is what it looks like:

```go
func (h Heating) MarshalJSON() ([]byte, error) {
    // Step 1
    if len(h.ExtraOptions) == 0 {
        type heating Heating
        return json.Marshal(heating(h))
    }

    var fields []reflect.StructField

    // Step 2
    t := reflect.TypeOf(h)
    for i := 0; i < t.NumField(); i++ {
        fields = append(fields, t.Field(i))
    }

    // Step 3
    for k, v := range h.ExtraOptions {
        fields = append(fields, reflect.StructField{
            Name: strings.Title(k),
            Type: reflect.TypeOf(v),
            Tag:  reflect.StructTag(fmt.Sprintf(`json:"%s"`, k)),
        })
    }

    // Step 4
    e := reflect.New(reflect.StructOf(fields)).Elem()
    e.FieldByName("Temperature").Set(reflect.ValueOf(h.Temperature))
    for k, v := range h.ExtraOptions {
        e.FieldByName(strings.Title(k)).Set(reflect.ValueOf(v))
    }
    itf := e.Interface()

    // Step 5
    return json.Marshal(itf)
}
```

Be cautious though, according to benchmarks, we can see that there’s an
important overhead using this method and the cost increases linearly with
the number of options passed.

```
BenchmarkMarhalJSON/With_0_CustomOption(s)-8	2000000	 788 ns/op
BenchmarkMarhalJSON/With_1_CustomOption(s)-8	 300000	4321 ns/op
BenchmarkMarhalJSON/With_2_CustomOption(s)-8	 200000	5645 ns/op
BenchmarkMarhalJSON/With_3_CustomOption(s)-8	 200000	7245 ns/op
```

