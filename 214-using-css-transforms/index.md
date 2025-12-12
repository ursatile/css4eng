---
examples: examples/index
layout: home
nav_order: 214
target_minutes: 15
title: "Using CSS Transforms"
word_count: 2042
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

## Transforms and Viewports

One important thing to notice about CSS transforms is that they're applied *after* the browser has finished laying out the document. If you use `scale` to make an element larger, the browser won't move other elements around to create space; if you `translate` an element so it's no longer within the browser window, the browser isn't going to add a scrollbar for it. If you do need to modify your layout to account for scaled, rotated or translated elements, you'll have to make the adjustments yourself.

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

CSS defines a bunch of named 3D transformation properties, as well as a 3D version of the `matrix()` transform we looked at a moment ago. To get the full impact of the 3D effect, you'll need to apply a `perspective` to the parent element. Without this, you can still apply 3D transformations, but you'll see them in what's called an *orthogonal projection*; objects don't appear smaller if they're further away from the "camera":

{% example 3d-transforms.html elements="body" iframe %}

A good way to understand the `perspective` keyword has nothing to do with CSS - it's to look at a Hollywood camera trick called a *dolly zoom*, memorably used by Steven Spielberg in the movie *Jaws* - notice how Chief Brody's face stays roughly the same size, while the background behind him changes dramatically? 


<video controls loop muted>
  <source src="./media/jaws-dolly-zoom.mp4" type="video/mp4" />
  Your browser does not support the video tag.
</video>
CSS doesn't (yet!) simulate the full range of camera settings used in 3D computer graphics, like field of view and focal length, but it might help to think of `perspective` as a shorthand for "how much dolly zoom do you want?"; small values are way up close with a very wide-angle lens, large values are very long shots with a very narrow lens.

## Understanding `preserve-3d`

Take a look at these two examples here:

{% iframe preserve-3d-translateZ.html elements="body" iframe %}

In the top example, the red cat is being translated `30vw` *towards* the viewer, but still appears *behind* the blue goose.

By default, every element in CSS has a completely isolated 3D transform context. Imagine we're painting each element on its own sheet of glass: when we translate, rotate and scale elements, we can't actually move them in real 3D space; we're drawing --- *projecting*, if you want to use the technical term --- that element onto its glass sheet, and then stacking those sheets in the order they appear in the HTML, remembering to account for `z-index` and stacking contexts.

If we want to use 3D transforms to move objects so that they actually appear in front of and behind each other, they need to share a common 3D transformation space. CSS does this using the `transform-style` property. In the lower of the two examples above the black `<div>` has `transform-style: preserve-3d` applied, and so when we move the red cat towards the viewer, it appears in front of the blue goose, regardless of the order of the elements in the underlying HTML.

So far, so good... but now check out what happens with rotation:

{% iframe preserve-3d-rotate.html elements="body" iframe %}

I've given the background a little transparency here, so you can see the effect more clearly: parts of the rotated elements are ending up *behind* the container.

The only solution I've found to this is to introduce a wrapper element, so you've got a parent element that actually places the content into the DOM, a wrapper element that doesn't do anything except establish the 3D transformation space, and then the individual child elements within that space:

{% example preserve-3d-with-wrapper.html elements="body" iframe %}

## Creating a 3D Cube

The classic 3D transform demo is to create a cube in 3D space, using six `<div>` elements for each side of the cube, and transforming them in 3D space. In this example I've included a spinning transformation effect - hover over the cube to see the animation:

{% example 3d-cube.html elements="style,body" iframe %}

This effect also demonstrates more clearly how the `perspective` property works: here's the same cube, with the same animation effect, but with four different perspective values:

{% iframe perspective.html %}

In the leftmost example here, the perspective distance is actually inside the cube, producing a very dramatic --- albeit almost entirely useless --- 3D effect.

## The Matrix Reloaded

Finally --- yep, you guessed it --- there's the `matrix3d` transform:

```css
transform: matrix3d(a1, b1, c1, d1, a2, b2, c2, d2, a3, b3, c3, d3, a4, b4, c4, d4)
```

$$
\begin{bmatrix}a1 & a2 & a3 & a4\\b1 & b2 & b3 & b4\\c1 & c2 & c3 & c4\\d1 & d2 & d3 & d4\end{bmatrix}
$$

You want to know what that does? I'd suggest buying a textbook on 3D computer graphics. 😎

## Transformation Summary

Just to recap, here's the complete list of CSS transform properties and what they do:

#### Translation

- `translate(𝑥)` – moves an element along the *x*-axis.
- `translate(𝑥,𝑦)` – moves an element along the *x*- and *y*-axes.
- `translate3d(𝑥,𝑦,𝑧)` – moves an element in 3D space along *x*, *y*, and *z*.
- `translateX(𝑥)` – moves an element along the *x*-axis only.
- `translateY(𝑦)` – moves an element along the *y*-axis only.
- `translateZ(𝑧)` – moves an element along the *z*-axis only.

#### Rotation

- `rotate(𝛼)` – rotates the element around the *z*-axis (in 2D).
- `rotate3d(𝑥,𝑦,𝑧,𝛼)` – rotates the element in 3D space around the vector (*x,y,z*) by angle *α*.
- `rotateX(𝛼)` – rotates the element around the *x*-axis.
- `rotateY(𝛼)` – rotates the element around the *y*-axis.
- `rotateZ(𝛼)` – rotates the element around the *z*-axis (same as `rotate()`).

#### Scaling

- `scale(𝑠)` – scales uniformly by factor *s* on both *x* and *y* axes.
- `scale(𝑠ₓ,𝑠ᵧ)` – scales by *sₓ* on the *x*-axis and *sᵧ* on the *y*-axis.
- `scale3d(𝑠ₓ,𝑠ᵧ,𝑠𝑧)` – scales in 3D space along *x*, *y*, and *z*.
- `scaleX(𝑠ₓ)` – scales only along the *x*-axis.
- `scaleY(𝑠ᵧ)` – scales only along the *y*-axis.
- `scaleZ(𝑠𝑧)` – scales only along the *z*-axis.

#### Skewing

- `skew(𝛼ₓ)` – skews the element by angle *αₓ* along the *x*-axis.
- `skew(𝛼ₓ,𝛼ᵧ)` – skews by *αₓ* along the *x*-axis and *αᵧ* along the *y*-axis.
- `skewX(𝛼ₓ)` – skews only along the *x*-axis.
- `skewY(𝛼ᵧ)` – skews only along the *y*-axis.

#### Matrix transforms

- `matrix(𝑎,𝑏,𝑐,𝑑,𝑒,𝑓)` – defines a 2D transformation matrix.
- `matrix3d(𝑎₁,𝑎₂,…,𝑎₁₆)` – defines a 3D transformation matrix using 16 values.

## Review & Recap

In this section, we've learned about how **CSS transforms** let you move beyond static presentation by translating, rotating, scaling, and skewing elements in 2D and 3D space.

* Named transforms like `rotate()`, `scale()`, and `translate()` are friendly aliases for specific matrix operations; you can also use `matrix()` and `matrix3d()` for full control.
* A *transform list* allows multiple transforms on one element, but order matters — they’re applied **right-to-left** because they’re based on matrix multiplication.
* 3D transforms introduce depth and distance; the `perspective` property controls how dramatic the effect looks.
* By default, each element has an isolated 3D context; using `transform-style: preserve-3d` gives child elements a common 3D space so that objects can appear in front of or behind each other.
* Classic demos include spinning 3D cubes and dolly-zoom-style effects; in practice, most use cases can be handled with the simpler alias transforms rather than raw matrices.





