---
title: "Go, the simple programming language"
date: "2011-11-11"
draft: true
---

By early 2018, it will have been three years since I've started writing Go. Go,
the *simple* programming language. I thought it would be a good time to reflect
on this language I've been nearly using on a daily basis, about its community,
its good and really bad parts.

![Main picture](/images/blue-gopher-on-grass.jpg)

# Simplicity

Go is simple. Simple because everywhere you're looking at, there's a new shiny
project, written in Go, tagged as either *fast* or *small* but always *simple*.
Quite honestly, reading the [Go language specifications][1] (June 28th, 2017
version), it's short. Take a look at the [Scala specifications][2] (2.11) for
instance... Yes, I know, it's like comparing apple and oranges. The point here
is that those two languages are both young (2009 and 2003 respectively) and
popular, even though they are so different. One may list all the technical
differences between the two. The thing is one seems and *feels* more simple
than the other. I think the language simplicity is one the reasons of Go
success.

> Hello, this is a really nice quote
>
> Wow on multiple lines,
> That's really cool

But simplicity does not only lies in language specs. The Go compilation process
has helped a lot since day one in that regard. As a statically compiled
language, helped with an out-of-the-box cross-platform compiler, the time from
development to deployment is really amazing. I have worked with high-quality
C++ libraries in the past. Whether the code documentation was good or bad, the
time was always lost at trying to properly compile when the library was not
bundle with a proper Autotools or Cmake configuration. And cross-platform is a
feature that has to been understood and well thought before starting the
project. I like the take of Go authors about this point. And time has proven
them right: look at the popularity around JVM-based languages (Java, Clojure,
Scala, Kotlin), Rust. After few years, Mono has finally made it to
Microsoft and pushed forward the migration of C# and .NET to non-Windows
platforms. Nowadays, you can confidently work on a different platform than the
production one.


 - Here is a list
 - And a second item in the list

And here is `some inlined code` inside a **bold** paragraph or an underline
__word__, and finally a ~~strike one~~.

- [ ] Todo 1
- [x] Todo 2
- [ ] Todo 3



```go
package main

import "fmt"

func main() {
    fmt.Println("vim-go")
    value := <-myChan
}
```

# Expressiveness

As often stated, simplicity often comes to the price of expressiveness.
Although I completely agree on that point, I don't think the price to pay is as
expensive as some may say.

* https://commandcenter.blogspot.fr/2017/12/error-handling-in-upspin.html
* With less expressivity comes more creativity.
* We were more creative when we needed to think about resource usage
* But code may have become more complex
* It's a balance to find


[1]: https://golang.org/ref/spec
[2]: https://www.scala-lang.org/files/archive/spec/2.11/01-lexical-syntax.html
