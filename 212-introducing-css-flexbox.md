---
examples: examples/212-introducing-css-flexbox
layout: module
nav_order: 212
target_minutes: 15
title: "Introducing CSS Flexbox"
word_count: 34
---

In this section, we're going to learn about a set of features and capabilities which are collectively known as CSS flexbox. They're defined in something called the CSS Flexible Box Layout Module, hence "flexbox"; the syntax was finalised around 2012, and achieved stable support across all mainstream browsers by 2017.

I spent a lot of time thinking about where to introduce flexbox in this course. There's one pretty strong argument that flexbox is the *de facto* standard layout model for modern CSS, and that if you know how to use flexbox effectively, you probably never need to use a lot of the things we've already seen, like floats and layout grids --- and so we could have learned about flexbox right at the beginning, used it for all the other demos and exercises, and skipped over all the other stuff entirely.

There are three reasons I didn't do that. First: you're going to find that stuff in the wild. Sure, if you're building a brand new greenfield web application starting today, you're probably going to build your layouts around flexboxes... but most of us aren't building greenfield applications, we're maintaining sites and systems which have been around for a while.

Second: I think taking the time to look at block and inline elements, floats, and layout grids provides a much better understanding of why flexbox was created, and what sort of problems it was intended to solve.

Third: flexbox is mind-meltingly complicated. It's a completely new layout model, with ten new properties to consider, all of which can interact with each other in complex and sometimes unexpected ways... for folks who've not worked with CSS before, it's a little overwhelming. But if you've already spent a bit of time using things like layout grids, flexbox will be like a breath of fresh air. Albeit slightly complicated air with a lot of interesting smells in it.

You ready? Let's see what it can do.

## Flexbox Fundamentals

Flexbox is designed to align elements in a container along a single axis; every flexbox container is fundamentally trying to be either a single row of things, or a single column of things. This is in contrast to the CSS Grid we'll meet a little later, which is all about two-dimensional layouts.

Also bear in mind that while you *can* use flexbox to lay out entire screens and applications, it's just as effective for building small standalone components, as we'll see later in this section.

To activate the flexbox layout system, you'll need a container element with `display: flex` on it --- or `display: inline-flex`, if you want your container to behave like an inline element.

That'll give you a container with a *main axis* and a *cross axis*, and just about everything else is defined in terms of those two axes.

{% example display-flex.html elements="body" iframe_style="height: 26em;" %}

By default, flex will try to fit every element onto the same row (or column), shrinking elements as necessary. Use `flex-wrap` if you want items to wrap across multiple lines

{% example flex-wrap.html elements="body" iframe_style="height: 26em;" %}

> You can also set the direction and wrap in one statement using the `flex-flow` shorthand property: `flex-flow: <direction> <wrap>;` 

## Justify and Align, Content and Items

This is where flexbox starts to get a bit gnarly, mainly because we just don't have enough specific words in everyday English for the number of different ways content inside a flexbox can be arranged.

`justify-content` controls how elements are arranged along the main axis, **if they don't fill the container**.

{% iframe justify-content.html style="height: 43em;" %}

There are several values there which appear to do the same thing:

* `left` and `right` are cardinal directions. They never change
* `start` and `end` will change based on the writing direction; in right-to-left reading systems like Hebrew and Arabic, `start` is the right, `end` is the left.
* `flex-start` and `flex-end` are relative to the `flex-direction`.
* 

Remember, though, this is justification **along the main axis**. You change the axis orientation or direction, it's going to produce a different effect:

{% iframe justify-content-column.html style="height: 27em;" %}

and if you reverse the flex direction, the start becomes the end, so to speak:

{% iframe justify-content-column-reverse.html style="height: 27em;" %}

















