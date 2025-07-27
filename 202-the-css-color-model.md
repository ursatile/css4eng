---
title: "The CSS Color Model"
layout: home
nav_order: 202
examples: examples/202-the-css-color-model 3283
target_minutes: 20
word_count: 0
---

In the last section, we looked at some examples of CSS selectors, using foreground and background colours to visualize the effects of different selectors, but so far the only colours we've seen are *named colours*.

## Named Colors

Back in the days of Netscape Navigator, HTML 3.0 defined a palette of sixteen named colours - the same colors supported by the Microsoft Windows VGA palette:

{% include_relative snippets/16-colors.html %}

Over time, CSS has also adopted named colours from various sources, including the X Windows System. MDN notes that “about 150 other colours have a keyword associated to them”, and Anthony Lieuallen has created this wonderful color wheel visualisation which you can use to explore them all:

<iframe src="snippets/named-color-wheel.html" style="height: 720px;"></iframe>

If you're curious how that works, the [code is available on Github](https://github.com/arantius/web-color-wheel) under an MIT license, and huge thanks to Anthony for creating that; I think it's fantastic.

There are some interesting historical details hidden in the CSS named color system... for example, there's a color called `darkgrey`, which is actually lighter than the color called `grey` - because `grey` came from the original 16-color VGA palette, and `darkgrey` was already defined by X Windows as a lighter shade than that. Many colours have two names - the hot-pink color beloved of CGA computer games and synthwave artists is called `magenta` and `fuchsia`, and you can spell `grey` with either an "a" or an "e" wherever it appears in a colour name.

The color `orange` was added to the CSS version 2 specification, after it turned out that Eric Meyer, the web standards advocate who created the official test suites for CSS verison 1, had used orange for many of his examples... it worked, and was widely supported by browsers at the time, but wasn't actually part of the CSS  specification, which meant all Eric's test suites were technically invalid.

The most recent addition to the CSS named color palette has a sad and beautiful story behind it. It's called `rebeccapurple`, and it was added to CSS in 2014 in memory of Eric's daughter Rebecca, who tragically died of brain cancer on her sixth birthday.

That's just one of the many, many ways that named colors have ended up in CSS, going way back to a Unix developer sitting down in the late 1980s with a box of Crayola crayons and programming colors like aquamarine and orchid into the X Windows color system.

Named colors are human. They have character, and history, and they're easy to read --- as long as you know that `gainsboro` is a light grey and 





