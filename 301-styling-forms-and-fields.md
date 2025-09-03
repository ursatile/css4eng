---
examples: examples/301-styling-forms-and-fields
layout: home
nav_order: 301
target_minutes: 15
title: "Styling Forms and Fields"
word_count: 10
---
Forms are the fundamental building blocks of interactive web applications. Everything we've looked at so far has been static content: users can scroll, click, and navigate around our content, but they're not really interacting with it.

The first iteration of HTML forms included a basic set of input types:

{% iframe basic-html-form-elements.html %}

HTML5 (which rolled out gradually from 2007-2014) introduced a whole bunch of new form types:

{% iframe html5-form-elements.html %}

There's a few things to bear in mind when you're working with HTML inputs.

First: with the exception of `<input type="file">`, they are all fancy ways to make a string. Really. Everything gets reduced to text, 'cos that's all HTTP knows how to deal with; when the HTML5 input types were rolled, out, browsers that didn't support them yet would fall back to a plain old `<input type="text">` --- or, more accurately, to `<input>`, since `"text"` is the default type --- so even if you couldn't pick a colour using a nice colour picker, you could at least type `#ff9900` into the box.

Second: you have very little control over how these form inputs actually behave. Something like the colour picker, for example - if you're using Firefox, it'll pop up the system colour picker, which looks like this on macOS:

![macos-firefox-color-picker](./images/macos-firefox-color-picker.png)

and like this on Windows:

![image-20250902231652183](./images/image-20250902231652183.png)

Safari on macOS has its own built-in colour picker widget:

![macos-safari-color-picker](./images/macos-safari-color-picker.png)

This is what you get on iOS:

<img src="./images/ios-color-picker.png" style="width: 320px; margin: 10px auto;" alt="iOS Color Picker Widget" />

and on Chrome and Edge on Windows, it's this:

![image-20250902232414600](./images/chrome-windows-color-picker.png)

The underlying problem here, of course, is that the web is a collision of conventions about what something like a button or a colour picker should look like. There's one argument that says that if you're running macOS, the buttons on the web pages should look like macOS buttons so your users know that they're buttons. There's another argument says that it's your website, your buttons should look like the rest of your website.

When it comes to styling form elements, you'll find there's a few different approaches used on sites around the web.

Styling Inputs and Buttons

You can style text fields and buttons like just about any other element - backgrounds, borders, gradients, fonts; all the techniques we've looked at so far in the course:

{% example inputs-and-buttons.html elements="style,body" iframe %}







