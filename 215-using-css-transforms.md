---
examples: examples/215-using-css-transforms
layout: home
nav_order: 215
target_minutes: 15
title: "Using CSS Transforms"
word_count: 7
---
Everything we've looked at so far is about static presentation; the only user interaction we've looked at is what happens when the user resizes their browser, or opens the page on a different device.

In the next part of the course, we're going to dive deep into using CSS to build and style interactive web applications; we'll look at styling form elements, validation, interaction design, transitions and animations, but before we do that, there's one more presentation feature I want to talk about: CSS transforms.

This is where we break out of the document paradigm completely and get into the raw, underlying computer graphics. CSS transforms allow us to stretch, rotate, scale, distort, and apply just about any other kind of geometric transformation to the elements on a page.

We'll start with the basic 2D transforms: `translate`, `scale`, `rotate`, `translate` and `skew`:

{% iframe basic-transforms.html %}

The `transform` property can take multiple values; this is known as a *transform list*, but pay attention to the order of the transforms. Rotating and *then* translating an element produces a completely different effect to translating and then rotating it.

And, just to make things extra interesting, transformations in a transform list are applied **from right to left**. If you want to know why... it's because CSS transforms, like all geometric transformations in computer graphics, are implemented using matrices. When you apply multiple transformations, CSS multiplies the transformation matrices to produce a single composite transformation. Matrix multiplication is not commutative (𝐴 × 𝐵 ≠ 𝐵 × 𝐴), and when you multiply matrices left-to-right, the *last* transformation in the expression is the one that gets applied *first*.

If you don't want to know why, that's also fine. The whole reason CSS has friendly aliases like `rotate` and `scale` is so you can use transforms do to useful things without having to know what a matrix is.

It's clearer to see from an example. Hover your mouse over each of these examples to see the transformations being applied in order:

{% iframe multiple-2d-transforms.html  %}

In case you're wondering, the animations here are pure CSS; we'll learn about those in the module on transitions and animation later.

CSS supports dedicated property aliases for the `scale`, `translate` and `rotate` transformations (but not `skew`, for some reason.):

{% example transform-property-aliases.html elements="body" iframe %}

Now, take a look at this example here:

{% example transform-list-multiple-properties-composite-transforms.html elements="style" iframe %}

At a glance, it looks like we're applying the same transformations - rotate > scale > translate - to all four spans, but we're not.

* `#example1` we've already seen: it's a **transform list**; transformations are combined from right-to-left and applied as a single composite transformation.
* `#example2`, we've specified the `transform` property three times - **but CSS is not procedural; it's declarative**. This doesn't create a composite transformation; the last one "wins". *(Imagine ordering ice-cream, and you keep changing your mind... "I'll have chocolate. No, vanilla. No, strawberry!". You're gonna get strawberry. Last one wins.)*
* `#example3` and `#example4`, we've used the property aliases to apply three different transformations to the element, but when you specify transformations like this, they don't get combined. Each transformation is applied in isolation, **and the coordinate system is reset each time**, so it doesn't matter what order they're applied in.

Finally, if you're into the whole matrix thing, you can provide your own matrix:

```css
transform: matrix(a, b, c, d, e, f);

/* applies the 2D transform matrix | a c e |
                                   | b d f |
                                   | 0 0 1 |
```

$\begin{bmatrix}A1 &A2 & A3\\A4 & A5 & A6 \end{bmatrix}$











