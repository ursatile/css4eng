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

And, just to make things extra interesting, transformations in a transform list are applied **from right to left**. If you want to know why? It's because they're based on matrices, and we'll talk about those in a moment.

If you *don't* want to know why, that's also fine. The whole reason CSS has friendly aliases like `rotate` and `scale` is so you can use transforms do to useful things without having to get your head around matrix arithmetic.

It's clearer to see from an example. Hover your mouse over each of these examples to see the transformations being applied in order:

{% iframe multiple-2d-transforms.html  %}

In case you're wondering, the animations here are pure CSS; we'll learn about those in the module on transitions and animation later.

CSS supports dedicated property aliases for the `scale`, `translate` and `rotate` transformations (but not `skew`, for some reason.):

{% example transform-property-aliases.html elements="body" iframe %}

Now, take a look at this example here:

{% example transform-list-multiple-properties-composite-transforms.html elements="style" iframe %}

At a glance, it looks like we're applying the same transformations - rotate > scale > translate - to all four spans, but we're not.

* `#example1` we've already seen, defines a **transform list**; transformations are combined from right-to-left and applied as a single composite transformation.
* `#example2`, we've specified the `transform` property three times - **but CSS is not procedural; it's declarative**. This doesn't create a composite transformation; the last one "wins". *(Imagine ordering ice-cream, and you keep changing your mind... "I'll have chocolate. No, vanilla. No, strawberry!". You're gonna get strawberry. Last one wins.)*
* `#example3` and `#example4`, we've used the property aliases to apply three different transformations to the element, but when you specify transformations like this, they don't get combined. Each transformation is applied in isolation, **and the coordinate system is reset each time**, so it doesn't matter what order they're applied in.

## The Matrix Has You, Neo

CSS transformations are all applied by using *matrices*; a very common technique used in computer graphics to rotate, skew, scale, and otherwise manipulate sets of coordinates in 2D or 3D space. 

All the named transformations - `scale`, `rotate`, `translate`, `skew` - are aliases for plugging specific values into a 3x3 matrix and then using this to transform your element's coordinates. When you define a transform list in CSS, the browser combines all the transformation matrices to produce a single composite transformation - and that's why the order matters, and why they get applied right-to-left. Matrix multiplication is not commutative (𝐴 × 𝐵 ≠ 𝐵 × 𝐴), and when you multiply matrices left-to-right, the *last* transformation in the expression is the one that gets applied *first*.

If you *really* want to know why? There are two conventions used in computer graphics: pre-multiplication and post-multiplication. They're both well-established --- Direct3D uses pre-multiplication, OpenGL uses post-multiplication --- and the folks who designed CSS had to pick one; they picked post-multiplication, which means the thing that's getting transformed is placed at the *end* of the chain, and reduces backwards.

Think of a transform list as a deep-nested function call. This transform:

```css
transform: <scale> <rotate> <translate> <skew>
```

is like calling a set of transformation functions:

➡️ `scale ( rotate ( translate ( skew ( shape ))))`  
➡️ `scale ( rotate ( translate ( skewed-shape )))`  
➡️ `scale ( rotate ( translated-skewed-shape ))`  
➡️ `scale ( rotated-translated-skewed-shape )`  
➡️ `scaled-rotated-translated-skewed-shape`  

If you're happy doing the whole matrix thing, you can provide your own matrix:

```css
transform: matrix(a, b, c, d, e, f);
```

will transform the element by applying the matrix:
$$
\begin{bmatrix}a & c & e\\b & d & f\\0 & 0 & 1\end{bmatrix}
$$

The best way I've found to think about how matrix transformations work is that they distort your axes. `(a,b)` distorts the x-axis - rotate it, skew it, stretch it. `(c,d)` distorts the y-axis, and `(e,f)` moves the origin. Then the element is drawn in that new, distorted coordinate system.

Now, I gotta say, matrix transformations are a big deal in almost every kind of computer graphics, but in all the time CSS has had transforms, I have never, ever had a scenario where I couldn't do what I needed using the built-in aliases.

## 3D Transforms

Hang on to your hats, folks; things are about to get deep... 'cos CSS transformations can also do 3D.

Now, this is a *completely different thing* to the `z-index` and stacking contexts which we learned about earlier. Best way to think of 3D transforms is that your element becomes a flatscreen which can play 3D graphics.

Here's a minimal example of a 3D effect that would be impossible (well, extremely difficult) to achieve using only 2D transformation: perspective.

{% example minimal-3d-transform.html mark_lines="16,27,28" elements="style,body" iframe %}

The key here is the `perspective` property applied to the body. Without this, you can still apply 3D transformations, but you'll see them in what's called an *orthogonal projection*; objects don't appear smaller if they're further away from the "camera", so you don't really get the full impact of the 3D effect.

{% example perspective.html elements="style,body" iframe %}

CSS defines a bunch of named 3D transformation properties, as well as a 3D version of the `matrix()` transform we looked at a moment ago.













