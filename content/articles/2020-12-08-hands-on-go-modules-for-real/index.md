---
title: "Hands-on Go modules... For real!"
date: "2020-12-09"
draft: true
---

Go modules are great. Yet, after being around for two years, we, Go developers,
are still strugling to use them properly. There has been
[some](https://research.swtch.com/vgo-mvs)
[efforts](https://blog.golang.org/using-go-modules) from the Go gang at Google
to educate us. Even though, the community is still looking around everytime we
need to upgrade a dependency or bump a major version. But perhaps it's just me.

After spending the last 4 years using Go daily, both as a user and as a library
maintainer, this is yet another anonymous attempt to help other Go users to get
used to the new Go modules. Before jumping into examples for Go users and
library authors, I'll first start by introducing what makes Go dependency
management unique. My hope is that it will better highlight the consequences in
the next two sections. This article is provided as-is and is not exempt from
mistakes due to my own misunderstanding or to the lack of proper documentation
from Google, you pick.

# Introduction to Go modules

A directory containing other subdirectories is nothing special. Put Go files
within this directory and its subdirectories, and you'll get Go packages. To be
precise, a Go package is a directory containing Go files. Now, if you put a
`go.mod` file in one directory, you turn that directory into a Go module, which
also contains all its subpackages.

In addition to the module itself, the `go.mod` files also declares the root path
which will be used to import the different packages of the module. It also
provides a minimal Go version to be used to import the package. Finally, it also
list the dependencies of the module i.e. other Go modules or non-modules which
are needed to build the module. Note that the latter is rather important:
`require` statements in the `go.mod` are able to declare Go dependencies which
are not declared as modules.

# What makes Go dependency management unique

From there, you may think that `go.mod` simply act like other languages' package
management tools: we declare dependencies with version constraints in a manifest
file, just like a `Gemfile` or a `package.json` for Ruby and JavaScript
respectively and call it a day.

That's not true.

Only minimum version can be specified as dependency version constraints in
`go.mod` files. If you were writing `Gemfile` or `package.json` files, it would
mean that all your dependencies would be written with the `>=` equal or higher
to constraint, such as `my-dependency >=X.Y.Z`. Last but not least, Go module
dependencies are constrained by the major version, according to semver. In other
languages' manifest files, this would translate by `my-dependency >=X.Y.Z,<X+1`.
However, unlike with other dependency management system, Go will not try to
fetch newer dependency versions when those are made available.

Now you may be wondering: why does the Go team thought of introducing such a
different model whereas everyone else was happy enough with the existing ones?
As always with the Go team, I've learned that this is not the right question to
ask. The right question is: what does it solve to do things this way? In my
understanding, the answer is build reproducibility. Go implements this by
enforcing Go projects -- binaries and libraries -- to declare minimum versions
of dependencies with which the module is able to build. By doing so, it
guarantees that even if newer versions of dependencies are released, the
packages will not try to build against them. This is indeed very different from
what other dependency managers are doing: because version constraints in other
dependency managers do not prevent dependency versions from being upgraded
randomly, two builds made from the same manifest files two days apart could very
well succeed and fail respectively. Worse, they can both build, with different
dependency versions. I've seen this issue being "solved" by developpers getting
used to commit and version the infamous lockfile -- `Gemfile.lock` or
`package.lock` in Ruby and JavaScript respectively -- without really understand
why. Doing so leads to the same result as declaring all dependencies in the
manifest file with `==` exact version locking such as `my-dependency ==X.Y.Z`.
While it solves the issue of build reproducibility, this looks like a testimony
to the fail attempt of "evergreen" projects which are always built against the
lastest and presumably (wrongly?) "better" dependency. That's why I came to
appreciate Go dependency manager: build are reproducible by default, without
relying on an misunderstood hack, while dependency upgrades remain the
responsibility of the humans, not silent tools.

Finally, the last misconception I'd like to address is that the `go.sum` file is
not a lockfile. As you can understand, the way Go manages its dependencies is
enough for Go not to require a lockfile to have reproducibe builds. In this
context, a lockfile would simply be redundant. The actual goal of the `go.sum`
file is to provide a checksum mechanism for the downloaded modules, which is
another level of security to ensure that reproducible builds are correct.

# Wrapping up with a demo

