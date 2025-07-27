---
title: "The CSS Color Model"
layout: home
nav_order: 202
examples: examples/202-the-css-color-model
target_minutes: 20
word_count: 0
---

In the last section, we looked at some examples of CSS selectors, using foreground and background colours to visualize the effects of different selectors, but so far the only colours we've seen are *named colours*.

## Named Colors

Back in the days of Netscape Navigator, HTML 3.0 defined a palette of sixteen named colours - the same colors supported by the Microsoft Windows VGA palette:

{% include_relative {{ page.examples }}/16-colors.html %}

Over time, CSS has also adopted named colours from various sources, including the X Windows System. MDN notes that “about 150 other colours have a keyword associated to them”, and Anthony Lieuallen has created this wonderful color wheel visualisation which you can use to explore them all:

<iframe src="{{ page.examples }}/web-color-wheel/index.html" style="height: 680px;"></iframe>

If you're curious how that works, the [code is available on Github](https://github.com/arantius/web-color-wheel) under an MIT license, and huge thanks to Anthony for creating that; I think it's fantastic.

There are some interesting historical details hidden in the CSS named color system... for example, there's a color called `darkgrey`, which is actually lighter than the color called `grey` - because `grey` came from the original 16-color VGA palette, and `darkgrey` was already defined by X Windows as a lighter shade than that. Many colours have two names - the hot-pink color beloved of CGA computer games and synthwave artists is called `magenta` and `fuchsia`, and you can spell `grey` with either an "a" or an "e" wherever it appears in a colour name.

The color `orange` was added to the CSS version 2 specification, after it turned out that Eric Meyer, the web standards advocate who created the official test suites for CSS verison 1, had used orange for many of his examples... it worked, and was widely supported by browsers at the time, but wasn't actually part of the CSS  specification, which meant all Eric's test suites were technically invalid.

The most recent addition to the CSS named colour palette has a sad story behind it. It's called `rebeccapurple`, and it was added to CSS in 2014 in memory of Eric's daughter Rebecca, who tragically died of brain cancer on her sixth birthday. It's a beautiful memorial, and perhaps, a reminder that behind all the elements and attributes, technology like CSS matters because the real value of the open web is the beautiful, fragile, and very human connections which it makes possible.

CSS has borrowed named colours from all kinds of places, going way back to a couple of Unix developers, Paul Ravelling and John C. Thomas, sitting down in the late 1980s, one with a Sinclair Paints catalogue, the other with a big box of Crayola crayons, and programming colour names like Dodger Blue, Aquamarine and Orchid into the X Windows colour system.

### Named System Colours

CSS also defines a set of names for *system colours* --- the colours used by the rest of the user's operating system. The idea is that you can say “hey, make the buttons on my web page the same colour as all the other buttons on that person's computer” so you can build web apps that reflect their desktop colour scheme and preferences.

{% include_relative {{page.examples}}/system-colors.html %}

If you're viewing this on the web, the example above is live --- so what you're seeing there is based on your own system settings. For comparison, here's two screenshots showing what that preview looks like for me running Windows 11 - first in **dark mode**:

<img src="{{ page.examples}}/system-colors-dark-mode.png"
onmouseover="this.src='{{page.examples}}/system-colors-light-mode.png';"
onmouseout="this.src='{{page.examples}}/system-colors-dark-mode.png';">

and then in **light mode**:

<img src="{{ page.examples}}/system-colors-light-mode.png"
onmouseover="this.src='{{page.examples}}/system-colors-dark-mode.png';"
onmouseout="this.src='{{page.examples}}/system-colors-light-mode.png';">

Look closely at `ButtonFace` and `ButtonText` --- you see how in dark mode, `ButtonFace` is a dark grey and `ButtonText` is white, because dark mode has white text on dark buttons, but in light mode it's black text on pale grey buttons?

System colours can be really useful for building sites and apps which respect your user's colour preferences, but be really careful to always use them in matching pairs. If you're setting an element's `background-color` to `Canvas`, you *must* set that element's `color` property to `CanvasText`, otherwise you risk ending up with black-on-black, or white-on-white.

## Colour and Accessibility

Colour and contrast is one of the most important considerations when it comes to making web content accessible. 

> It's a common misconception that accessibility is about 

Here's what it looks like done badly.

{% example color-and-accessibility.html iframe_style="height: 16em;" %}













Named colours are human. They have character, and history, and they're easy to read --- as long as you know that `gainsboro` is a light grey and `peru` is a sort of pale brown color. But, as you saw with the Swedish flag exercise in the last section: if the color you want doesn't have a name, you're out of luck.

Fortunately, named colours isn't the only way to specify colour values in CSS.

## The RGB Colour Model

Inside every computer screen are millions of tiny pixels, and every pixel is made up of three elements - one red, one green, one blue. If you zoom in really close with a magnifying glass or something, you can see the individual RGB components of each pixel, but in everyday use, they're so tiny, and so close together, that your eyes just kinda smush the elements together. If they're all dark, that pixel looks black. If they're all lit up as bright as they can, that pixel looks white.

This is the additive color model, and it works because of how human eyes work... inside our eyes are two different kinds of photosensitive cells. One set of cells, known as *rods*, are sensitive to light and shade; we've got about a hundred million of those, they work great in dim light, they're great at perceiving fine detail, but they can't detect colour. The other set are called *cones*, and there are three types of cones: some are sensitive to red light, some to green, some to blue. Say you go outside on a bright sunny day and look at a yellow car. Sunlight is white - it's a mixture of all visible frequencies. Everything turned all the way up. Sunlight bounces off the car, which absorbs most of that light, but one particular frequency bounces off the car and into your eye. You don't have a receptor for yellow light; what actually happens is that light activates the red and green cone cells, but not the blue one - and, because it's bright, it activates the rods as well, and then your brain kinda mashes those inputs all together and goes "oh, hey, bright yellow!"

By the way, you might have learned in school that the primary colours are red, yellow and blue... that's true when you're mixing paint, or printer ink, because when you're working with paint or ink you're starting with a bright white surface, like a blank sheet of paper, and then making it darker. This is known as a subtractive color model; children mixing paint in school tend to use red, yellow and blue, while printer ink mixes cyan, magenta, and yellow. Screens and projectors use an *additive* colour model: you start with black and make it brighter by adding different colours of light until you get the colour you want.

So... you can get pretty much any colour you like on a computer screen, by specifying how much red, how much green, and how much blue to mix together.

Next question, then: how do you specify that? Most modern computers use 24-bit colour; we get eight bits for each of the red, green and blue channels, and eight bits is enough to count from zero up to two hundred and fifty five.

That gives us sixteen million, seven hundred and seventy seven thousand, two hundred and sixteen different possible colours. That sounds like a lot, but there's actually some applications where that's not enough: professional video editing systems often use 30-bit color - 10 bits per channel - and many of the effects in Adobe applications like Photoshop use 48-bit color internally, with 16 bits per channel, so that color precision doesn't get lost if, say, you put a darken filter on top of a brighten filter. I'm not sure why you'd do that... but if you did, Photoshop's got your back.

For the web, though, 8 bits per channel is plenty.

### Opacity and Alpha







The most readable way to work with CSS RGB color values is to use the `rgb` function, which takes three decimal numbers for the red, green, and blue components, respectively:

{% example rgb-colors.html iframe_style="height: 230px;" %}

You can also write rgb colours with each component as a percentage:

{% example rgb-colors-percentages.html iframe_style="height: 230px;" %}

By far the most common way to write RGB colors on the web, though, is to use something called hexadecimal notation, often shortened to `hex`.

Now, if your background is in computer science, you've worked with languages like C or done any systems programming, you've probably seen hex before - in which case you might want to skip ahead a few minutes. But if you've found your way into web development via graphic design, or art, or publishing --- as many, many people have --- hex codes are one of those things that might make you stop and go "hold on... what?"

I'm going to give a very short explanation, but if you're still not clear on it, by all means go away and read up on it before coming back to this course; this next section is going make way more sense if you're happy reading and writing hexadecimal numbers.

Short version: humans have ten digits, because we have ten digits. We have the numerals zero, one, two, three, four, five, six, seven, eight, nine, we have ten fingers --- well, eight fingers and two thumbs --- on our hands, and we count in base ten. We don't have a numeral for ten; we get as far as nine, then we stick a one in the tens column and the units goes back to zero. And when we get to ninety-ine, stick a one in the hundreds column and the others go back to zero.

Hexadecimal --- which gets its name from the Greek word for six, `hex`, and the Latin word for tenth, `decimal`, because English is a messed-up language --- is base sixteen. When we get past nine, we don't move to the tens... we count a, b, c, d, e, f, and THEN add a column. So zero through nine are the same as decimal numbers. a in hexadecimal is ten of something, b is eleven, c is twelve, f is fifteen, and then one-zero is sixteen.

A CSS hex colour code looks like `#0246ac`

The hash `#` indicates it's a colour code, and it's followed by six hexadecimal digits , `02`, `46`, then `ac`.

* `02` in decimal is 2, which is practically zero, so our colour has almost no red in it.
* `46` in decimal is 70, which is very roughly a quarter of 255, so we've got a bit of green.
* `ac` in decimal is 172, which is quite a lot of blue

so that colour is <span style="background-color: #0246ac; padding: 4px;">a rich, vivid blue with a touch of green in it.</span> (see?)

You'll also occasionally see hex codes written with three digits instead of six - `#fff` instead of `#ffffff`. 

There are some developers out there who can glance at a colour and make a pretty good guess at the RGB values - and hex codes - for that colour, and who can glance at a hex code and know exactly what tint and shade it is. I am not one of those developers. I can spot the easy ones - `#00ff00` is obviously bright green, a colour code like `#252525`, where all three digits are the same, is obviously a shade of grey - but fortunately, editors like VS Code have fantastic support for editing CSS colour codes.

































