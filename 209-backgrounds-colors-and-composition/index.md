---
layout: home
nav_order: 209
target_minutes: 15
title: "Colors and Composition"
word_count: 3039
---
In section 202, we learned about the CSS colour model, about named colours, system colours, specifying colours using RGB, HSL, or one of the other colour models supported by CSS.

In this section, we're going to learn about various other techniques and functions we can use in CSS to control the appearance of our elements, starting with background.

## Background

We've already met the `background-color` property, which we've used in several demos so far in the course, but CSS can do a lot more with backgrounds than just set them to a solid colour.

One of the oldest web design techniques is using images as element backgrounds, and over the years CSS has added properties that give us a huge amount of control over exactly how an image should be used as a background.

We'll kick off with the simplest possible example:

{% example simple-background-image.html elements="style" iframe_style="height: 20em;" %}

The background image is shown at its native size --- 100x100 pixels in this example --- and covers the whole background with a repeating tile pattern.

The `background-repeat` property takes one or two parameters; if you give it two parameters, the first one is the horizontal repeat, the second is the vertical:

* `repeat` - the default; repeat the image to cover the entire background area, clipping if it overflows the element's content area.
* `no-repeat` - just show the image once
* `space` - repeat the image as many times as possible, but leave a space between adjacent tiles so that none of them get clipped.
* `round` - stretch (distort) the image rather than clipping it. If the element will accommodate 1.49 backgrounds, you'll get a single tile stretched to fit. If the element will accommodate 1.5 backgrounds, you'll get two tiles, shrunk to fit. The tile's aspect ratio is not preserved.
* `repeat-x`: shorthand for `repeat no-repeat`
* `repeat-y`: shorthand for `no-repeat repeat`

{% iframe background-repeat.html %}

`background-size` controls, well, the size of the background: `contain` makes the background small enough that the element *contains* at least one full copy of the background; `cover` shrinks the background enough to *cover* the element, and crops any overmatter. If you specify background-size a single unit, that sets the width of the element; if you specify two units, that's width and height.

{% iframe background-size.html %}

`background-attachment` controls how the element's background responds to scrolling - is the background attached to the viewport (`fixed`), to the document (`scroll`), or to the element itself (`local`) ? You'll also notice if you look closely at this example that if the `background-attachment` is set to `fixed`, then the `background-size` is relative to the viewport, not the element itself:

{% iframe background-attachment.html style="height: 22em;" %}

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

### Angles in CSS 

 We briefly met CSS angles when we looked at colour wheels in the section on CSS colour models. Angles crop up in all kinds of places in CSS --- most obviously, in the functions for rotating an element, which we'll meet later --- but they're also used to specify the direction of a `linear-gradient`, and the postions of the colour stops when using a `conic-gradient`.

You can specify angles in CSS using:

* Degrees: `90deg`. One full circle is 360 degrees. (You knew that, right?)
* Radians: `3.1416rad`; a full circle is 2π radians (but you can't use π as a number in CSS, so working in radians you'll end up with lots of decimal places )
* Gradians: `100grad`. A full circle is 400 gradians; 100 gradians is a right angle.
* Turns. `0.5turn` - a full circle is 1 turn.

The full docs are over on MDN if you need them: [https://developer.mozilla.org/en-US/docs/Web/CSS/angle](https://developer.mozilla.org/en-US/docs/Web/CSS/angle)

For the `linear-gradient` function, you can specify the *direction* of the gradient, as an angle:

{% example css-linear-gradient-angles.html elements="style,body" iframe_style="" %}

For radial gradients, you can specify the gradient's origin point, independently of the background position:

{% example radial-gradient-origin.html elements="style,body" iframe_style="" %}

For conic gradients, you can specify both the origin point, and the starting angle:

{% example conic-gradient-origin.html elements="style,body" iframe_style="" %}

There's also a repeating version of each gradient:

{% example css-repeating-gradients.html elements="style, body" iframe_style="height: 15rem;" %}

Watch out for the difference between a **repeating gradient**, and **repeating a gradient**; you can also use a regular non-repeating gradient pattern to create a single background tile, and then repeat that tile across the element's background. One particularly neat trick here is to use a conic gradient to create one "tile" of a repeating chequerboard pattern:

{% example repeating-css-gradients.html elements="style" iframe_style="height: 23rem;" %}

## Composing Multiple Backgrounds

OK, so you've seen about five hundred different ways to use an image as the background of an element... important, but not exciting.

What makes CSS backgrounds really useful is that an element can have more than one background - and we can control how multiple backgrounds are combined, giving us a way to create some really cool visual effects.

How about a background photograph, and then overlaying that with a transparent gradient effect?

{% example background-image-with-gradient.html elements="style" iframe_style="height: 26em;" %}

Or combining multiple repeated gradients with a handwriting font to create something reminiscent of a school exercise book?

{% example exercise-book.html element="style" iframe_style="height: 20em;" %}

The thing to remember about composing multiple CSS backgrounds is that you need to provide multiple values for each property:

```css
background-image:     <image1>     <image2>,    <image3>,    <image4>;
background-size:      <size1>,     <size2>,     <size3>,     <size4>;
background-position:  <position1>, <position2>, <position3>, <position4>;
```

The first background is drawn closest to the viewer, the final background is drawn furthest away from the viewer, and only the final image can be a solid colour (even if that colour has transparency; if you need a transparent colour layer as part of a background stack, use a gradient that only defines one colour).

## Background Shorthand

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

## z-index

Using absolute positioning, we can have elements in a document which are painted over the top of each other. 3D computer graphics traditionally uses three coordinates `(x,y,z)`, where `x` is horizontal, `y` is vertical, and the `z`-axis is pointing either away from the viewer into the screen, or out of the screen towards the viewer, depending which system you're using. CSS doesn't use a true 3D coordinate system, but we can "move" elements forwards or backwards in the rendering stack using a property called the `z-index`. 

{% example z-index.html elements="body" iframe_style="height: 8.5em;" %}

`z-index` can take any integer value, including negative values to move something backwards in the display stack. In practice, you'll see it used in two ways. Well-engineered CSS tends to use small z-index values - 3, 4, 5 - to assign elements to a predetermined series of layers, because somebody sat down and figured it all out in advance and a well-engineered site will seldom have more than half-a-dozen elements in a render stack.

In my experience, it's also common to see z-index values like `99` and  `999` because some long-suffering maintenance developer has to add a cookie warning banner or a chat popover window or something, and the only way to get it to appear on top of all the existing elements on the page is to use a very high `z-index`. 

> If you're curious, `z-index` is a 32-bit signed integer in all modern browsers, which means the highest `z-index` you can have is (2^31-1) = 2147483647. But hey - twenty one billion layers ought to be enough for anybody, right?

Stacking elements like this is relatively simple when they're all solid: you only see the one at the front. But once we start introducing concepts like opacity, it can get very interesting indeed.

{% example z-index-with-opacity.html elements="body" iframe_style="height: 8.5em;" %}

Notice how in this example, the boxes in the middle have `opacity` applied to the entire element, so it affects the text and border as well as the background, whereas the boxes on the right are opaque elements with a transparent background, so the text and border is still drawn at full intensity.

## Stacking Contexts

A stacking context defines a group of associated elements that will be stacked independently of any other group of elements. Every page has at least one stacking context, created by the root `<html>` element, and giving just about element a `z-index` will create another stacking context - check out [features creating stacking contexts](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_positioned_layout/Stacking_context#features_creating_stacking_contexts) at MDN if you want the full list. It's not very interesting.

{% iframe stacking-contexts.html style="height: 24em;" %}

If you want to create a new stacking context without specifying a `z-index`, use the `isolation: isolate` property. This is particularly useful for controlling the composition of the `::before` and `::after` pseudo-elements without affecting the originating element's position in the document stack.

{% iframe isolation.html style="height: 28em;" %}

## Using CSS Blend Modes

In all the examples above, we only see the further layer if the nearer layer has some transparency to it; if foreground background layers are fully opaque, the background layer is completely covered and doesn't affect what ends up on the screen.

Multiple backgrounds is one of the places where we can use something called blend modes; a bunch of algorithms that started out in fundamental computer graphics, made their way into applications like Photoshop, and have ended up baked into browsers as part of the latest CSS standards.

Before we go any further, there are two things to bear in mind about blend modes and filters. First: you can use them to create just about any effect imaginable; by combining blend modes, you can create literally thousands of different effects. 

Second: the vast majority of those will not yield anything useful. Many of them won't actually do anything at all. It's incredibly hard to predict what a given combination of blend modes will actually do, and using them in your own code often boils down to a lengthy iterative process of trial and error. There are a handful of genuinely useful applications of CSS blend modes, and once in while you'll find a scenario where a background blend mode actually solves a problem, but if you're staring at them going "...why would I ever use this?", you're not alone.

The descriptions here are taken directly from the [MDN documentation on blend modes](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode):

- [`normal`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#normal)

  The final color is the top color, regardless of what the bottom color is. The effect is like two opaque pieces of paper overlapping.

- [`multiply`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#multiply)

  The final color is the result of multiplying the top and bottom colors. A black layer leads to a black final layer, and a white layer leads to no change. The effect is like two images printed on transparent film overlapping.

- [`screen`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#screen)

  The final color is the result of inverting the colors, multiplying them, and inverting that value. A black layer leads to no change, and a white layer leads to a white final layer. The effect is like shining two projectors onto the same screen.

- [`overlay`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#overlay)

  The final color is the result of `multiply` if the bottom color is darker, or `screen` if the bottom color is lighter. This blend mode is equivalent to `hard-light` but with the layers swapped.

- [`darken`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#darken)

  The final color is composed of the darkest values of each color channel.

- [`lighten`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#lighten)

  The final color is composed of the lightest values of each color channel.

- [`color-dodge`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#color-dodge)

  The final color is the result of dividing the bottom color by the inverse of the top color. A black foreground leads to no change. A foreground with the inverse color of the backdrop leads to a fully lit color. This blend mode is similar to `screen`, but the foreground need only be as light as the inverse of the backdrop to create a fully lit color.

- [`color-burn`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#color-burn)

  The final color is the result of inverting the bottom color, dividing the value by the top color, and inverting that value. A white foreground leads to no change. A foreground with the inverse color of the backdrop leads to a black final image. This blend mode is similar to `multiply`, but the foreground need only be as dark as the inverse of the backdrop to make the final image black.

- [`hard-light`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#hard-light)

  The final color is the result of `multiply` if the top color is darker, or `screen` if the top color is lighter. This blend mode is equivalent to `overlay` but with the layers swapped. The effect is similar to shining a *harsh* spotlight on the backdrop.

- [`soft-light`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#soft-light)

  The final color is similar to `hard-light`, but softer. This blend mode behaves similar to `hard-light`. The effect is similar to shining a *diffused* spotlight on the backdrop.

- [`difference`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#difference)

  The final color is the result of subtracting the darker of the two colors from the lighter one. A black layer has no effect, while a white layer inverts the other layer's color.

- [`exclusion`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#exclusion)

  The final color is similar to `difference`, but with less contrast. As with `difference`, a black layer has no effect, while a white layer inverts the other layer's color.

- [`hue`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#hue)

  The final color has the *hue* of the top color, while using the *saturation* and *luminosity* of the bottom color.

- [`saturation`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#saturation)

  The final color has the *saturation* of the top color, while using the *hue* and *luminosity* of the bottom color. A pure gray backdrop, having no saturation, will have no effect.

- [`color`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#color)

  The final color has the *hue* and *saturation* of the top color, while using the *luminosity* of the bottom color. The effect preserves gray levels and can be used to colorize the foreground.

- [`luminosity`](https://developer.mozilla.org/en-US/docs/Web/CSS/blend-mode#luminosity)

  The final color has the *luminosity* of the top color, while using the *hue* and *saturation* of the bottom color. This blend mode is equivalent to `color`, but with the layers swapped.

Here's what they look like. 

{% iframe mix-blend-mode.html style="height: 28em;" %}

To apply blend modes to multiple background on the same element, use `background-blend-mode`; if you want to blend elements against other elements, use `mix-blend-mode`.

One particularly useful example of blend modes is creating duotone images to use as element backgrounds:

{% example duotone-background.html elements="style" iframe_style="height: 17em;" %}

For a full duotone effect, sometimes known as a split tone, you can apply one tint to the shadows and a separate tint to the highlights by using a `::before` and `::after` pseudoelement, with different `mix-blend-mode` properties applied to the `::before` and `::after` layer.

{% example split-tone-background.html elements="style" iframe_style="height: 17em;" %}

In this example, I've used a `:hover` pseudo-class to reveal the unfiltered background image when you mouse-over each element; this effect also relies on very specific combinations of colours, so you'll need to experiment if you want to recreate it using your own colour palette and images.

## CSS Filters and Stacking Elements

We can do some pretty cool things using layered backgrounds, but if we want to get really creative, we need to learn about CSS filters.

Using the `filter` property, we can apply a range of visual effects to any element in the document.

{% example basic-filters.html elements="style,body" iframe_style="height: 32em;" %}

You can combine multiple filters on a single element; if you do this, remember that filters are applied in the order they're defined; applying `contrast` after `blur` will produce a very different outcome to applying `blur` after `contrast`:

{% example combined-filters.html elements="style" iframe_style="height: 14em;" %}

Backdrop Filter

And finally... backdrop filter. You know that cool translucent effect you sometimes see on things like Windows Terminal?

Yeah. We can totally do that. If you apply any of the CSS filter functions using the `backdrop-filter` property, they'll be applied to the background that appears behind the target element.

{% example backdrop-filter.html elements="style" iframe_style="height: 24em;" %}

Backdrop filters are particularly useful for darkening a background image behind elements, so you can ensure that light-coloured text remains legible without completely covering the background - and like before, you can combine multiple filters in a single property to achieve effects like solarization.

## Review and Recap

In this section, we've learned about CSS backgrounds, blend modes, stacking contexts, and filters --- all features we can use to control how overlapping elements are *composed* by the browser.

* We've learned about background properties like `background-repeat`, `background-size`, `background-attachment`, `background-origin`, `background-clip` and `background-position` control how an element's background is composed relative to the element itself
* We learned how to use linear, radial, and conic gradients to create various kinds of background effects - and the difference between a repeating gradient, and repeating a gradient.
* We've seen how to give an element multiple backgrounds, how to control their stacking order, and how to use the `background` property shorthand to define multiple properties in a single rule
* We've met `z-index`, `isolation`, and stacking contexts, use to control the rendering order of overlapping elements
* We've used CSS blend modes to create visual effects like duotone backgrounds
* We've used CSS filters like `blur()` and `brightness()` to change the appearance of elements, and used `backdrop-filter` to apply visual effects to an element's backdrop.

## Links and References

Compositing and Blending In CSS by Sara Souiedan
: [https://www.sarasoueidan.com/blog/compositing-and-blending-in-css/](https://www.sarasoueidan.com/blog/compositing-and-blending-in-css/)

The CSS property you didn't know you needed by Francesco Vetere
: [https://dev.to/francescovetere/the-css-property-you-didnt-know-you-needed-3fk0](https://dev.to/francescovetere/the-css-property-you-didnt-know-you-needed-3fk0)

Exploring CSS Isolation Property: Enhancing Web Design with Stacking Contexts
: [https://levelup.gitconnected.com/exploring-css-isolation-property-enhancing-web-design-with-stacking-contexts-87dedfa0f2c0](https://levelup.gitconnected.com/exploring-css-isolation-property-enhancing-web-design-with-stacking-contexts-87dedfa0f2c0)

















