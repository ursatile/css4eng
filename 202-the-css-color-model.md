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

The CSS nam





