---
examples: examples/210-backgrounds-colors-and-composition
layout: home
nav_order: 210
target_minutes: 15
title: "Colors and Composition"
word_count: 720
---
In section 202, we learned about the CSS colour model, about named colours, system colours, specifying colours using RGB, HSL, or one of the other colour models supported by CSS.

In this section, we're going to learn about various other techniques and functions we can use in CSS to control the appearance of our elements, starting with background.

## Background

We've already met the `background-color` property, which we've used in several demos so far in the course, but CSS can do a lot more with backgrounds than just set them to a solid colour.

One of the oldest web design techniques is using images as element backgrounds, and over the years CSS has added properties that give us a huge amount of control over exactly how an image should be used as a background.

We'll kick off with the simplest possible example:

{% example simple-background-image.html elements="style,body" iframe_style="height: 4em;" %}

The background image is shown at its native size --- 128x128 pixels in this example --- and covers the whole background with a repeating tile pattern.

The `background-repeat` property takes one or two parameters; if you give it two parameters, the first one is the horizontal repeat, the second is the vertical:

* `repeat` - the default; repeat the image to cover the entire background area, clipping if it overflows the element's content area.
* `no-repeat` - just show the image once
* `space` - repeat the image as many times as possible, but leave a space between adjact tiles so that none of them get clipped.
* `round` - stretch (distort) the image rather than clipping it. If the element will accommodate 1.49 backgrounds, you'll get a single tile stretched to fit. If the element will accommodate 1.5 backgrounds, you'll get two tiles, shrunk to fit. The tile's aspect ratio is not preserved.
* `repeat-x`: shorthand for `repeat no-repeat`
* `repeat-y`: shorthand for `no-repeat repeat`

{% iframe background-repeat.html %}

`background-size` controls, well, the size of the background: `contain` makes the background small enough that the element *contains* at least one full copy of the background; `cover` shrinks the background enough to *cover* the element, and crops any overmatter. If you specify background-size a single unit, that sets the width of the element; if you specify two units, that's width and height.

{% iframe background-size.html %}

`background-attachment` controls how the element's background responds to scrolling - is the background attached to the viewport (`fixed`), to the document (`scroll`), or to the element itself (`local`) ? You'll also notice if you look closely at this example that if the `background-attachment` is set to `fixed`, then the `background-size` is relative to the viewport, not the element itself:

{% iframe background-attachment.html %}

`background-origin` controls whether the top-left corner - the `origin` - of the background is relative to the element's border, padding, or content:

{% iframe background-origin.html style="height: 16em;" %}

`background-clip` determines whether the background fills the border, padding, or content box of the element, or only applies to the actual letterforms of the element's text.

> In CSS, the border is always drawn over the top of the background, so `border-box` clipping is only visible if the border has transparency or transparent regions

{% example background-clip.html elements="body" iframe_style="height: 16em;" %}

and `background-position` sets the initial position of the background image, relative to the `background-origin`:

{% iframe background-position.html style="height: 30em;" %}

## CSS Gradients

One of the most useful features of modern CSS is buried in the spec as a syntactical footnote to the `background-image` feature, because as well as specifying the background image as a URL, you can use a CSS gradient as a background.

Technically, CSS treats a gradient as a special kind of image, and supports three basic gradients - linear, radial, and conic:

{% example basic-css-gradients.html elements="style, body" iframe_style="height: 15rem;" %}

You can specify the exact position of the colour stops in a gradient:

{% example css-gradients-with-stops.html elements="style, body" iframe_style="height: 15rem;" %}

There's also a repeating version of each gradient:

{% example css-repeating-gradients.html elements="style, body" iframe_style="height: 15rem;" %}

## Multiple Backgrounds and Stacking Contexts

OK, so you've seen about five hundred different ways to use an image as the background of an element... important, but not exciting.

What makes CSS backgrounds really useful is that an element can have more than one background - and we can control how multiple backgrounds are combined, giving us a way to create some really cool visual effects.

How about a background photograph, and then overlaying that with a transparent gradient effect?

{% example background-image-with-gradient.html elements="style" iframe_style="height: 26em;" %}

Or combining multiple repeated gradients with a handwriting font to create something reminiscent of a school exercise book?

{% example exercise-book.html element="style" iframe_style="height: 20em;" %}

The thing to remember about composing multiple CSS backgrounds is that you need to provide multiple values for each property:

```css
background-image: <image1>, <image2>, <image3>, <image4>;
background-size: <size1>, <size2>, <size3>, <size4>;
background-position: <position1>, <position2>, <position3>, <position4>;
```

The first background is drawn closest to the viewer, the final background is drawn furthest away from the viewer, and only the final image can be a solid colour (even if that colour has transparency; if you need a transparent colour layer as part of a background stack, use a gradient that only defines one colour).

## Using CSS Shorthand

So far, almost every example we've seen has explicitly specified each property in turn. Many CSS features also support a shorthand syntax we can use to specify multiple related properties using a single rule. In the case of backgrounds, the shorthand property is `background`, followed by one more background layers, separated by commas, where each layer is specified using a shorthand syntax which includes one or more of:

* `background-image`
* `background-position`
* `/ background-size`  - *note that size must follow position, and they must be separated with a `/`*
* `background-repeat`
* `background-origin`
* `background-clip`
* `background-attachment`
* `background-color`

Here's an example of a five-layer background, specified using the `background` shorthand:

{% example background-shorthand.html elements="style" iframe_style="height: 20em;" %}

## CSS Filters and Stacking Elements

We can do some pretty cool things using layered backgrounds, but if we want to get really creative, we need to learn about CSS filters.

Using the `filter` property, we can apply a range of visual effects to any element in the document.

{% example basic-filters.html elements="style,body" iframe_style="height: 20em;" %}





- Using css `filter`: `blur()`, `brightness()`, `contrast()`, `drop-shadow()`, `grayscale()`, `hue-rotate()`, `invert()`, `opacity()`, `saturate()`, `sepia()`

## Notes













