---
examples: examples/304-using-css-grid
layout: home
nav_order: 304
target_minutes: 15
title: "Using CSS Grid"
word_count: 332
---
In the beginning, there was the document flow, and there were block and inline elements, and lo, it was sort of OK, and if it wasn't you could always use float, and developers went "but how do we get a header here and a footer there and a left and right hand navigation and have the whole thing responsive across different layouts" and the World Wide Web Consortium went "we don't know maybe you could do it using tables?"

And then there was the 12-column layout, and the CSS flexbox, and it was good, and developers went "yeah, this is all awesome but what if I want to a layout that's responsive in two different directions at the same time?" and the WHAT-WG, which by now had replaced the World Wide Web Consortium when it came to This Kind Of Thing, went "what, you want, like, flexbox, but with rows *and* columns?" and the developers went "yes!" and the WHAT-WG went "Oh, ok, I guess we could build some sort of grid system" and developers went "YES A GRID SYSTEM!"... and so CSS Grid was born.

## Why Use CSS Grid?

The first thing to remember --- and this applies to just about everything we've seen so far in this course --- is that none of it is mutually exclusive. Choosing CSS layout modules isn't like choosing Python vs nodeJS, or React vs Angular; you can mix and match. You can absolutely have a site where you have individual grid-based components used in flex-based sections in a page that's using a legacy 12-column layout grid; in fact, many of the examples I've shown so far in this course use a flex or a grid just to lay out a handful of elements inside a div or a section.

Flow vs Grid vs Flex 

{% example flow-vs-grid-vs-flex.html elements="style,body" iframe %}





# Using CSS Grid (30m)

## Course Content

- Display: `grid` and `inline-grid`
- Grid-template columns, rows, areas
- grid-colum (+ start and end)
- grid-row (+ start and end)
- grid-area
- place - items, content, self
- justify and align
- auto grids - flow, columns and rows

## Notes













