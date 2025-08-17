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

There are two reasons I didn't do that. First: you're going to find that stuff in the wild. Sure, if you're building a brand new greenfield web application starting today, you're probably going to build your layouts around flexboxes... but most of us aren't building greenfield applications, we're maintaining sites and systems which have been around for a while.

Second: I think taking the time to look at block and inline elements, floats, and layout grids provides a much better understanding of why flexbox was created, and what sort of problems it was intended to solve. Flexbox







