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

Named colors are human. They have character, and history, and they're easy to read --- as long as you know that `gainsboro` is a light grey and `peru` is a sort of pale brown color.

But, as you saw with the Swedish flag exercise in the last section: if the color you want doesn't have a name, you're out of luck.

Fortunately, named colours isn't the only way to specify colour values in CSS.

The RGB Colour Model

Inside every computer screen are millions of tiny pixels, and every pixel is made up of three elements - one red, one green, one blue. If you zoom in really close with a magnifying glass or something, you can see the individual RGB components of each pixel, but in everyday use, they're so tiny, and so close together, that your eyes just kinda smush the elements together. If they're all dark, that pixel looks black. If they're all lit up as bright as they can, that pixel looks white.

This is the additive color model, and it works because of how human eyes work... inside our eyes are two different kinds of photosensitive cells. One set of cells, known as *rods*, are sensitive to light and shade; we've got about a hundred million of those, they work great in dim light, they're great at perceiving fine detail, but they can't detect colour. The other set are called *cones*, and there are three types of cones: some are sensitive to red light, some to green, some to blue. Say you go outside on a bright sunny day and look at a yellow car. Sunlight is white - it's a mixture of all visible frequencies. Everything turned all the way up. Sunlight bounces off the car, which absorbs most of that light, but one particular frequency bounces off the car and into your eye. You don't have a receptor for yellow light; what actually happens is that light activates the red and green cone cells, but not the blue one - and, because it's bright, it activates the rods as well, and then your brain kinda mashes those inputs all together and goes "oh, hey, bright yellow!"

By the way, you might have learned in school that the primary colours are red, yellow and blue... that's true when you're mixing paint, or printer ink, because when you're working with paint or ink you're starting with a bright white surface, like a blank sheet of paper, and then making it darker. This is known as a subtractive color model; children mixing paint in school tend to use red, yellow and blue, while printer ink mixes cyan, magenta, and yellow. Screens and projectors use an *additive* colour model: you start with black and make it brighter by adding different colours of light until you get the colour you want.















