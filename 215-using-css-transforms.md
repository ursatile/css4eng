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

You can apply multiple transforms to the same element, but if you do this, pay attention to the order of the transforms; they're all applied relative to the same origin, so applying a translation followed by a rotation will produce a different effect to rotating and *then* translating:

{% example multiple-2d-transforms.html %}
