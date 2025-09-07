---
examples: examples/903-speech-bubbles
layout: home
nav_order: 903
target_minutes: 5
title: "Exercise: Speech Bubbles"
word_count: 10
---
## Exercise: Creating Pure CSS Speech Bubbles

From time to time in my career, I've been asked to make a web UI that looks like a chat app - iMessage, WhatsApp, those kinds of conventions.

The actual layout is fairly simple, but creating a speech-bubble effect using pure CSS requires some neat tricks using pseudo-elements and the triangular border trick we looked at earlier.

We're going to end up with something that looks like this:

{% iframe speech-bubbles.html %}

## Basic Speech Bubbles

There's no specific HTML element for conversation - it's actually covered in the WHATWG's HTML living spec [section 4.14.3 Conversations](https://html.spec.whatwg.org/multipage/semantics-other.html#conversations) as an example of a scenario that isn't covered by any specific elements.

{% example speech01.html iframe %}

First, we'll use the `left` and `right` classes to apply a border, background colour, and horizontal alignment to the lines of dialogue:

{% example speech02.html elements="style" iframe %}

Next, we're going to use a `::before` pseudo-element to add the first part of the "tail". We'll use the same rule for both left and right classes, only overriding it for the specific details which actually differ between the two.

Notice that we've also added `position: relative`to the `p` rule for the speech bubbles, so that we can then use absolute positioning on the pseudo-elements to line them up with the border of the paragraph:

{% example speech03.html elements="style" iframe %}

Finally, we'll use an `::after` pseudo-element to draw another triangle; this one's going to be white, and gives the effect of a hollow tail with an outline around it. We'll also give the `body` element `4em` of bottom padding, so the final tail doesn't overflow the viewport and force a scrollbar:

{% example speech04.html elements="style" iframe %}

## Exercises

### Colour Coding

Colour the dialogue, so that each participant has their own colour.

* How would you do this for a group chat with more than two participants?

### Consecutive Comments

Imagine the same person posts multiple comments: how would you only display the speech bubble tail on the final comment in a group?

### Avatars

How would you extend this example to include an avatar image next to each participant in a group chat?









