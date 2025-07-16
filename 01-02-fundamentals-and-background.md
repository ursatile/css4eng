---
title: "Fundamentals and Background"
layout: home
nav_order: 10102
---

### Why Do So Many Developers Struggle With CSS?

We're going to kick off with a question: why do so many developers struggle with CSS? I've worked with a lot of really talented, capable developers in my career, proper full stack developers who were as happy working with SQL databases as they were writing HTML, and over the years it's noticeable how many of them really didn't enjoy working with stylesheets. We'd be working through a new feature - database schema migrations, new classes, backend, HTML, JavaScript, all absolutely fine, and then when it comes to styling the frontend... that was always the bit that nobody wanted to pick up.

Well, I think there's a couple of good reasons for that. 

First: CSS has a fundamentally different programming model from a lot of the other languages we work with. Now, there are folks out there who will tell you CSS isn't even a programming language. The best way to deal with those people is ask them to draw a heading in 72 point dark blue Times New Roman using C++ and come back when they've done it. CSS absolutely is a programming language - it's a structured language, with a formal grammar, that we can use to control part of a computer system. But CSS, on it's own, doesn't do anything. You can't write an app using 100% CSS - CSS only works when you combine it with HTML, which means it's often treated as an "afterthought" - first you make it work, THEN make it look nice. But, as you'll see over the next few hours, CSS should never be an afterthought, and there is way more to it than just making websites look nice.

Second: CSS isn't procedural, it's declarative. With languages like JavaScript or C#, you can read the code by starting at the beginning and following a series of instructions - do this, then do that, then do that. Of course, it's not always quite that easy, but that procedural style means you can pause the program halfway through, attach a debugger, figure out exactly what's going on right now - it's step-by-step, like following a recipe. CSS is more like ordering takeaway food: you just specify what you want, and when it works? Awesome. But when it doesn't work, you've got to work out why - and that could mean unpicking dozens of different CSS rules defined across different files and modules, figuring out which ones are applicable, which rules override other rules, how those rules interact with whatever else is on the page - and that's hard. In this course, I'm going to show you a bunch of techniques I've learned over the course of my own career for debugging and troubleshooting CSS, and how you can use those to make sense of what's going on.

Third: I think our industry has, historically, not done a great job teaching CSS as an engineering discipline. There's a lot of great books and courses out there about CSS, but many of them are aimed at designers - folks who work with Photoshop or Figma, who understand the principles of graphic design, layout, colours and typography. You don't need to be a great designer to be a great developer - some of the best developers I've worked with were absolutely terrible when it came to visual design - but you do need to understand the capabilities of the tech you're working with.

Fourth: CSS is hard to test. It doesn't crash. It usually doesn't produce error messages. If you accidentally change a heading from being 100 pixels high to being 10 pixels high, it's not going to break the build; your code still works, it just looks wrong - and unless you pick it up during manual testing, you're not going to know about that until somebody files a bug saying "the website looks weird".

And finally, and probably because of all the reasons we just talked about: most CSS you'll find in the wild is terrible. Development teams focus on features, data, performance; the CSS gets bolted on as an afterthought, hacked around using increasingly complex rules until it sort of mostly looks good enough... then the next developer comes along, can't make any sense of what's already there, and every time they modify it somebody complains that it's broken something on a completely different part of the website, so instead of being evolved and maintained over time, we just keep adding new layers on top of everything that's already there, until you've got a site with ten different kinds of buttons on it and nobody knows what'll break if you change one.

Now, if you're one of the folks for whom all of the above feels painfully true, I have bad news: CSS isn't going away. Ever. It's one of the fundamental building blocks of the web. You can write your backend and your microservices in anything you like - Java, C#, PHP, Go - but when it comes to end users, the best way to deliver your solution is the web, and the web runs on HTML, JavaScript, and CSS. Even desktop applications these days are often built using frameworks like Electron, which rely on CSS for styling and interaction design.

There is good news too, though - and the good news is that CSS is actually pretty awesome now. If, like a lot of developers, you learned a bit of CSS early on in your career and haven't really gone back to it, you're in for all kinds of fun. We've got grids and flexbox layouts, animations, keyframes, transformations... CSS even has variables now. A lot of layouts and designs that used to be really complicated are now fairly straightforward - and those new features also mean we can build all kinds of new interfaces and capabilities into our web applications. Sound good? Alright, let's kick things off.

### HTML and Semantic Markup

OK, first things first. As we've already seen, CSS, on its own, doesn't do anything. You can't build an application using only CSS; to understand how CSS works, you need to understand its relationship to HTML - the Hypertext Markup Language.

Start with the basics. Almost every website and application is going to draw stuff on your screen. Words and images. The words might be there for you to read them - headings, articles, paragraphs - or they might be parts of the user interface: labels, menus, drop-down lists. Images might be content - diagrams and photographs - or they might be icons, buttons, or other interactive elements.

HTML is how we control the structure of all that content. It gives us a way to organise content into containers, to sort and group the various bits of content that make up our website or application - and, by default, it applies some very basic visual styling to that content.

There have been numerous "official" versions of HTML over the years, going all the way back to HTML 1.0 in the early 1990s, and for a long while those versions were maintained and managed by the W3C, the World Wide Web Consortium. The most recent numbered version was HTML5, published in 2014 - but along the way, Apple, Mozilla and Opera announced that they were going to collaborate on a different approach to evolving HTML, via something called the Web Hypertext Application Technology Working Group - or the what-double-you-gee, or the what-wee-gee, or the what-wig, depending who you're talking to.

Consequently, HTML no longer has version numbers: instead, it's controlled by something called the HTML Living Standard. This is a continuously-evolving document that describes how HTML works: folks like us can use it to look up HTML tags, attributes and syntax, and the folks who build web browsers use it as a reference for making sure their browser engines will render those same tags, attributes and syntax properly.

Now, remember that the web is a moving target. At any given point, there's a bunch of features out there which will work in some browsers, but aren't yet supported in others. There's things which are coming soon, which you can opt in to if you want to try them out; there's things which are deprecated, and so you probably shouldn't use them in your projects - but they, mostly, still work. With a handful of exceptions, most notably Java applets and plugins like Shockwave and Flash, everything that *has* ever worked on the web will *still* work on the web; it's just there might be a better way to do it now.

Let's create a really simple web page, just to remind ourselves of the basics - and to establish a few conventions that we'll be using throughout the rest of the course. 

```html
{% include_relative examples/01-02-fundamentals-and-background/index.html %}
```

Our page opens with a DOCTYPE declaration. This tells the browser that we're sending it modern HTML - it was introduced as part of HTML 5, and at the time, if you didn't include this DOCTYPE declaration, browsers would fall back to using a legacy rendering model sometimes known as "quirks mode", which meant they could include support for the latest features and standards - activated by the DOCTYPE - but still render older pages and sites. It's not such a big deal any more out on the open web, where the vast majority of sites use relatively modern code, but there's a lot of corporate intranets and embedded systems out there which still rely on quirks mode.

Next up, HTML.














# Fundamentals and Background (20m)

## Course Content

- Why do so many developers struggle with CSS?
  - Approaches and methodologies
- HTML and semantic markup
- The structure of CSS: syntax, selectors, inheritance, cascading, nested CSS
- Inline vs internal vs external
- How browsers read CSS
- Web Content Accessibility Guidelines (WCAG)

## Notes
