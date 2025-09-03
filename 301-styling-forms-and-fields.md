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

## Styling Inputs and Buttons

You can style text fields and buttons like just about any other element - backgrounds, borders, gradients, fonts; all the techniques we've looked at so far in the course:

{% iframe inputs-and-buttons.html %}

## Styling Radio Buttons and Checkboxes

Historically, browsers haven't given developers a huge degree of control over the appearance of radio buttons and checkbox inputs.

Incidentally, if you've ever wondered why they're called radio buttons? It goes all the way back to old-fashioned car radios, which had buttons to choose a preset radio station - and because you can't tune in to two radio stations at the same time, pushing one button would release all the others. Just like how radio buttons work on the web.

![shutterstock_1067043515-radio-buttons](./images/shutterstock_1067043515-radio-buttons.jpg)

Even 30 years after HTML 3.2, there's still a lot of subtle detail about radio buttons and checkboxes that many developers haven't encountered before. By way of  a quick recap: radio buttons only let the user select one value from a group - denoted by a set of inputs with the same `name` attribute. Radio buttons, and groups of related checkboxes, should always be contained in a `<fieldset>` element, along with a `<legend>` element which explains the what that group of inputs is for. 

Because they're relatively small, radio buttons and checkboxes should always have an associated `<label>` element - it's much easier to click on the adjacent label text than it is to click on the radio button or checkbox itself.

One way to accomplish this is to put the input *inside* the label:

{% example radio-buttons-inside-labels.html elements="style,body" iframe %}

Another way is to give each radio button an ID, and use the `for` attribute to associate the labels. Remember that radio buttons in a group have the same name, so you have to give them a unique ID which can't be the same as their name.

{% example radio-buttons-with-associated-labels.html elements="style,body" iframe %}

Despite this being part of the HTML standard since the 1990s, you'll still see a lot of forms in the wild where the "label" isn't actually a `<label>` element - it's just some text alongside the button. This *looks* the same, but try making a selection here:

{% example radio-buttons-without-labels.html elements="style,body" iframe %}

If you find this easy, have a couple of drinks and then try doing it on your phone on a moving train - a completely valid technique for understanding what it's like to use your software for somebody who has limited dexterity. The WCAG refers to this particular issue as [target size](https://www.w3.org/WAI/WCAG21/Understanding/target-size.html); WCAG level AA requires a minimum target size of 24x24 pixels, and for compliance with level AAA (the highest accessibility standard) targets should be [at least 44x44 pixels](https://www.w3.org/WAI/WCAG21/Understanding/target-size.

The problem with styling radio buttons and checkboxes is that on almost all devices, they aren't drawn by the browser - they're drawn by the operating system, so properties like border and background have no effect.

One option if you're wrapping your inputs in a `<label>` element is to style the label; you'll need to tweak the positioning a bit to get it to look good, but thanks to modern CSS' support for the `:has()` selector, it's easy to style the label associated with the selected checkbox to make it more obvious which one's selected:

{% example radio-buttons-and-checkboxes.html elements="style" iframe %}



