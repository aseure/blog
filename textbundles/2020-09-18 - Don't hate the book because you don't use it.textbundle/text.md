# Don't hate the book because you don't use it

In a few months, I'll celebrate my fifth year as a professional - understand paid - software engineer. I find this role to be a right balance of technical skills, human relationships and it fulfils my curiosity. As time goes by, I'm also starting to be disappointed by some of its negative aspects. While it doesn't prevent me from sleeping, I think an effort could be made to challenge some lousy and short-sighted comments we see daily on social platforms.

Today, I'd like to talk about [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.amazon.com/Design-Patterns-Object-Oriented-Addison-Wesley-Professional-ebook/dp/B000SEIBB8), a book written by Erich Gamma, Richard Helm, Ralph Johnson, and John Vlissides, famously known as the _Gang of Four_. If you never read it: this is a fundamental programming book describing programming abstractions published in 1994. The date is essential here, but we'll come to that later.

This book has recently been discussed by many, due to [a recent tweet from Robert. C. Martin aka Uncle Bob](https://twitter.com/unclebobmartin/status/1306581616983183361). Long story short, telling a massive audience that book X is great, and treating people who consider it outdated as "foolish" does not end well.

While I disagree with the tone here, I'd like to focus on the negative comments which followed, including but not limited to:

- the book is outdated
- its concepts are outdated
- its authors said it's outdated
- the book is only focused on mid-90s C++ developers
- no one ever used the "flyweight" design pattern
- the book is not even readable
- its abstractions make code unreadable

First of all, let's get back to 1994. I was two at the time. All Internet websites could probably fit on a floppy disk, Jeff Bezos founded Amazon, Rasmus Lerdorf was only starting to work on its _Personal Home Page/Forms Interpreter_ CGI C program, and Larry Page and Sergey Brin would only start their research project for a web search engine two years later. The biggest technology companies were IBM, Hewlett-Packard, Motorola and Xerox, which mostly sat behind the oil, car, and food industries. Programming existed, but it wasn't the same field as we know it today. Tech companies were a few, and I assume a lot of programmers were working in other industries. Being a professional in this sector was arguably more difficult then, and knowledge was not as easily accessible as it is today. This book was published in a world where programming started to spread in many industries. It surely was a very good resource, to try to apply its concepts, and see what works and what doesn't. The authors were literally inventing the field at the time: Erich Gamma, for instance, teamed up with Kent Beck to create the Java JUnit test framework just a few years later, which hugely helped to popularise testing.

My point is: let's remind ourselves we stand on the shoulders of many people who tried and experimented a lot at the time. We too often take for granted the knowledge and productivity we have today. On top of that, let's not be disrespectful towards the previous generation. My father and my grandfather both work(ed) as electricians: never did my father complain about his father's tools or habits before him. He learned them and perfected them with modern knowledge.

Now about the book in itself. While I agree with people saying that some design patterns are too abstract, I strongly disagree with the ones saying the whole book is outdated. Should you develop in a OO language today, such as Java, C++, Python or Ruby, or even more notably, develop a framework or a tool _for_ developers, I think this book is still highly relevant today.

Here are my top picks from the book and why I chose them.

**Builder:** because in OOP, objects often hold too much data in them, you need to control how to instantiate them properly. Even with overloaded constructors, data validation at instantiation can become messy. Do you like your testing framework using a _fluent interface_ with method chaining (`assert(...).not().equalTo(...)`)? Guess what, it's directly inspired by the builder design pattern.

**Prototype:** I often hear people complaining about how complicated JavaScript is. While I don't think this language makes it easy for the developer to write non error-prone code, I better understood the language via the lens of its prototype-based nature, precisely described by the prototype design pattern.

**Most of the structural patterns:** While everyone is focused on the bad parts of OOP, namely inheritance, all those design patterns are focused on composability. If you want to be cool nowadays, you could say you prefer "composition over inheritance". Well, if you think composition is only about embedding objects in each other, you should read the part of structural design patterns. For instance, you probably know decorators from Python or annotations in Java/C#, they derive from the decorator design pattern.

**Chain of Responsibility:** I think we can all agree on how great it is to use and implement a middleware in our modern web framework. Just use or write functions which take a _next_ handler, a request object. Pass it to your web framework instance via a `.use(...)` method and you're done. This is what the Chain of Responsibility pattern is all about. All Rails, Django, and Laravel developers knew that was NIH.

**Iterator:** This one seems obvious now, perhaps not so much at a time where iterating on arrays with pointer arithmetic was common. Today, iterators are even buried behind standard libraries to implement even higher abstract functionalities, but they are still there. I don't see a more universal way to implement, with the same public API, a traversal of an array, a tree, or a graph (they are better ways of iterating those last data structures though).

**Observer:** For this last one, here is the verbatim definition from the book: "Define a one-to-many dependency between objects so that when one object changes state, all its dependents are notified and updated automatically". Now, if we take a look at some modern technologies, doesn't this resonate with PubSub models or React hooks for instance?

To conclude, I'm not saying the book is not old, quite the opposite: you can feel it when it takes as examples from 90s user interfaces. I'm merely advocating that our industry and its workers have changed a lot in the last 30 years, dare I say even more than in any other industry. But this should not be an excuse to sweep away years of meticulous R&D and documentation, on which our modern tools still rely on nowadays, and the people behind it.

Because a lot of people complained that they were never able to finish the book, here is an extract from the end, section "What to Except from Design Patterns", page 351:

> It's possible to argue that this book hasn't accomplished much. After all, it doesn't present any algorithms or programming techniques that haven't been used before. [...] it just documents existing designs. You could conclude that it makes a reasonable tutorial, perhaps, but it certainly can't offer much to an experienced object-oriented designer.
>
> We hope you think differently. Cataloging design patterns is important. It gives us standard names and definitions for the techniques we use. If we don't study design patterns in software, we won't be able to improve them, and it'll be harder to come up with new ones.
>
> This book is only a start.
