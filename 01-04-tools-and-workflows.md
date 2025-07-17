---
title: "Tools and Workflows"
layout: home
nav_order: 10104
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

The next thing to check out is the dev tools built into your browser. Every modern browser includes a built-in toolkit for inspecting and debugging HTML, CSS and JavaScript; they have fairly similar feature sets, but vary slightly depending on which browser you're using.

There are really only three browser engines that are still relevant in 2025. By far the most popular is an engine called Blink. This is the engine that's used in an open-source brosChromium, the open source project that most modern browsers are based on







- Debugging CSS with browser dev tools
- Managing CSS - using a "kitchen sink" page
- Using CSS rules for debugging: background-color and outline
- Checking CSS support at caniuse.com

## Notes
