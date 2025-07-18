---
title: "Tools and Workflows"
layout: home
nav_order: 10104
examples: "examples/01-04-tools-and-workflows"
typora-root-url: .
typora-copy-images-to: ./images
---

In the previous section, we learned the rudiments of CSS syntax, and how to associate styles with our web content.

Before we go any further, let's learn about some tools, tricks, and techniques we'll be using during the rest of the course, to help us develop, test, and debug CSS rules.

We're going to be using Visual Studio Code as our code editor throughout this course; it's free, it's cross-platform, and it has built-in CSS language features for formatting and syntax highlighting CSS.

## Closing The Feedback Loop: Live Reload

When you're writing CSS, the vast majority of your time will be spent checking that rules have done the right thing - which means reloading the page in your browser and seeing what's changed. The faster this feedback loop, the faster you'll be able to get things working properly.

The ideal rendering model here is sometimes called "live reload": you make a change in your editor, and it appears instantly in the browser window before you've even saved the file. Now, you might already have a setup like that, using something like Vite or Webpack - if you do; awesome. That'll work just fine. If not, here's a couple of options to try out.

### VS Live Preview

My favourite extension for this kind of development is called Live Preview:

* [https://marketplace.visualstudio.com/items?itemName=ms-vscode.live-server](https://marketplace.visualstudio.com/items?itemName=ms-vscode.live-server)

By default, Live Preview opens an embedded browser inside VS Code, and changes appear as you edit your source code - you don't even have to save the file. If you want to change that, open the VS Code Settings UI, search for "Live Preview", and you can tell it to only update when you save a file, to use an external browser (and which one to use), and a whole bunch of other settings:

![image-20250717183649962](images/vs-code-live-preview-settings-screenshot)

### VS Live Server

There's another VS plugin called Live Server, which always uses an external browser and automatically reloads your content when you save a file:

* [https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer)

and at the time I'm writing this, there's a beta version of Live Server ++ available on Github which supports live reload without saving the file, so if you like the sound of live reload and for whatever reason the Live Preview extension doesn't work for you, check that out.

## Using the Browser Dev Tools

The next thing to check out is the dev tools built into your browser. Every modern browser includes a built-in toolkit for inspecting and debugging HTML, CSS and JavaScript; they have similar feature sets, but vary slightly depending on which browser you're using.

There are really only three browser engines that are still relevant in 2025. By far the most popular is an engine called Blink: Google Chrome, Microsoft Edge, Opera, the Samsung mobile browser, boutique browsers like Arc, Brave and Vivaldi - they're all based on an open source browser project called Chromium, and Blink is the engine that powers Chromium.

The two notable exceptions are Apple's Safari browser, used on macOS and iOS devices, which is based on Apple's Webkit rendering engine, and Firefox, which uses its own rendering engine, known as Gecko.

If you're on a Chromium-based browser, you'll find the Developer Tools under More Tools - or press Ctrl-Shift-I, or right-click an element on the page and choose "Inspect". Firefox is the same - More Tools, Ctrl-Shift-I, or right-click, Inspect; you can also right-click an element and press Q to open the inspector. On Safari on macOS, they're under the Develop menu, or Cmd-Option-I.

I'm going to use the Chromium dev tools for most of the examples in this course, unless we're looking at something specific to Firefox or Safari. We'll start here, with the element inspector.

### Using the Element Inspector

The inspector lets us inspect any element in our page, to see exactly where that element fits into the structure of the page, and which CSS rules the browser is applying to that element.

What makes it particularly useful is that the inspector also shows us the HTML structure of our document, so we can either inspect an element by clicking on the rendered version - the web page - or by clicking on the source. As we learn about CSS properties like position and visibility, you'll discover there are all sorts of ways that an element can appear in a completely different place in the output than it does in the source code - or maybe even not appear at all.

Let's inspect our heading 1. It's got a `element.style` that's setting `color` to `green`, and then everything else is being provided by what's called the *user agent stylesheet*.

The term **user agent** comes from [RFC9110](https://httpwg.org/specs/rfc9110.html#user.agent), the document which defines many of the technical terms used to refer to web systems and standards. Strictly speaking, a user agent is any piece of software which makes network requests on behalf of a user. In this course, the user agent will almost always be a web browser - but user agents could also be bots, scripts, command-line tools; even something like a wifi-connected lightbulb that connects to a web API. 

In this instance, the user agent is our web browser, and the user agent stylesheet is the set of default styles that the browser will use if we haven't overridden them with CSS rules.

If we take a look at the `em` element that's inside our paragraph, you'll see that it's inheriting its color from the parent element - the paragraph - and the rest is defined by that user agent stylesheet.

Now, add another rule to `styles.css`:

{% highlight css mark_lines="5 6 7" %}
{% include_relative {{ page.examples }}/styles.css %}
{% endhighlight %}

![image-20250718155004640](./images/chrome-inspector-screenshot-with-em-styles)

When the page reloads, you can see in the inspector the new rule is being applied, that that rule is defined in styles.css, line 5 - and also that it **overrides** the existing rule which says paragraphs should be purple. This is happening because of something called *specificity*: when deciding what color to make that emphasis element, the teal rule is more *specific* than the purple rule, because the teal rule specifically targets the `em` element, whereas the purple rule is *inherited* from the paragraph. We'll talk way more about specificity 

- Debugging CSS with browser dev tools
- Managing CSS - using a "kitchen sink" page
- Using CSS rules for debugging: background-color and outline
- Checking CSS support at caniuse.com

## Notes
