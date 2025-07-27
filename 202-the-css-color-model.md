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

The named color `orange` was 

The most recent addition to the CSS color palette has a sad and beautiful story behind it. It was added in 2014 as a memorial to Eric Meyer's daughter Rebecca. Eric is a tireless advocate for web standards, particularly CSS, and after Rebecca tragically died of brain cancer on her sixth birthday, her favourite color was added to the CSS specification as `rebeccapurple`. 





