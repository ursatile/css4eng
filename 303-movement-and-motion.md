---
examples: examples/303-movement-and-motion
layout: home
nav_order: 303
target_minutes: 20
title: "Movement and Motion"
word_count: 244
---
The web has always rested on three pillars: HTML controls structure, CSS controls presentation, JavaScript controls behaviour.

At least, that's the theory. It's valid up to a point... but like any taxonomy, the boundaries between the regions are a little fuzzy, and they even move around from time to time.

Animation was historically considered behaviour, but as the web has matured, we've realised that much of the time animation is actually about presentation. Movement and motion can be used to draw your user's attention to an element, such as an invalid form field; to show and hide dynamic navigation elements, or to create a sense of flow as people move between different parts of a page or application. None of these things change the underlying *behaviour* of the system—they’re all about how information is presented and how the experience feels. 

Consequently, animation features like transitions, keyframes and easing functions have gradually moved out of JavaScript and become part of CSS.

## Animation using `transition`

Here's a page with three `<div>` elements on it. Each of them does something different when you hover the mouse over it:

{% example divs-without-transitions.html elements="style,body" iframe_style="" %}

Using the CSS `transition` property, we can specify:

* Which property we want to animate
* How long the transition should take
* What *easing function* to apply
* How long to wait before running the transition (default: `0s`)

You *can* specify each one individually:

```css
transition-property: color, margin-right, height;
transition-duration: 1s, 2s, 3s;
transition-timing-function: linear, ease-in, ease-out;
transition-delay: 3s, 2s, 1s;
```

But this is definitely a scenario where you're better off using the equivalent shorthand property:

```css
transition: 
	color 1s linear 3s,
	margin-right 2s ease-in 2s,
	height 3s ease-out 1s;
```

Here's our set of `<div>` elements with a very basic transition applied:

{% example divs-with-transitions.html elements="style,body" iframe_style="" %}

## What Can We Animate?

The short answer is... just about anything. The vast majority of properties in CSS can be animated; a full list of them all would take way more time than we have here, and by the end of it we'd all be extremely bored.

Broadly speaking, there are two kinds of animatable properties in CSS - *continuous*, and *discrete*. Continuous animation (also known as "computed value") means the browser can calculate the full range of intermediate values, and so create a smooth animated transition from the initial to the final state. 

For our `background-color` example, it calculates the intermediate red, green, and blue values for every animation frame; for the `height` example, it calculates the intermediate heights.

For something like `font-family`, there's no mathematical way to specify what's halfway between Times New Roman and Arial, so the animation is `discrete`. By default, this means it'll flip immediately, but in this case we've used the `transition-behavior: allow-discrete` property, which will flip it at the halfway point of the transition duration; in this case, we've specified the duration as `1s` so the font family changes after half a second.

## Timing Functions

Timing functions create smooth, natural animations by simulating real-world physics effects like inertia. First, an interactive example:

{% example timing-functions.html elements="style,body" iframe_style="" %}

Timing functions are based on a mathematical function called a cubic Bezier curve. Sounds complicated. It's not, really --- or rather, it uses some complicated mathematics behind the scenes, but you don't need to grok the maths to build your own curves, because there's a Bezier curve viewer and editor built in to browser dev tools.

I actually prefer the curve editor in Firefox, because it's easier to create curves which overshoot the animation range --- useful to create a sort of bouncy kinetic effect which I rather like. Open the Inspector, find an element with a transition timing function, and click the tiny icon next to it:

![image-20250828233041427](./images/firefox-click-to-open-the-timing-function-editor.png)

Once open, you can use the editor to select from various preset timing functions, or create your own timing curves by dragging the Bezier node handles; it'll update the CSS in the Styles inspector and you can copy the results back into your own code.

![image-20250828232759976](./images/firefox-timing-function-curve-editor.png)

The equivalent in Chrome is accessed in a very similar way, and provides mostly the same capability --- the only limitation is that the size of the curve editor is limited because it assumes we're not going to overshoot.

![image-20250828231925584](./images/chrome-dev-tools-bezier-curve-editor.png)

One more useful thing to know is that the `transition-property` property accepts a keyword `all`, meaning "animate every property that's animatable."

{% example transition-property-all.html elements="style,body" iframe_style="" %}



Advanced Animation



Course Content

- Animations and CSS transitions
- Triggering interactions: hover, click, scroll, JS events
- Parallax scrolling
- Exercise: animated airline departure board grid

## Notes













