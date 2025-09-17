---
examples: examples/304-using-css-grid
layout: home
nav_order: 304
target_minutes: 15
title: "Using CSS Grid"
word_count: 1601
---
In the beginning, there was the document flow, and there were block and inline elements, and lo, it was sort of OK, and if it wasn't you could always use float, and developers went "but how do we get a header here and a footer there and a left and right hand navigation and have the whole thing responsive across different layouts" and the World Wide Web Consortium went "we don't know maybe you could do it using tables?"

And then there was the 12-column layout, and the CSS flexbox, and it was good, and developers went "yeah, this is all awesome but what if I want to a layout that's responsive in two different directions at the same time?" and the WHAT-WG, which by now had replaced the World Wide Web Consortium when it came to This Kind Of Thing, went "what, you want, like, flexbox, but with rows *and* columns?" and the developers went "yes!" and the WHAT-WG went "Oh, ok, I guess we could build some sort of grid system" and developers went "YES A GRID SYSTEM!"... and so CSS Grid was born.

## Why Use CSS Grid?

The first thing to remember --- and this applies to just about everything we've seen so far in this course --- is that none of it is mutually exclusive. Choosing CSS layout modules isn't like choosing Python vs nodeJS, or React vs Angular; you can mix and match. You can absolutely have a site where you have individual grid-based components used in flex-based sections in a page that's using a legacy 12-column layout grid; in fact, many of the examples I've shown so far in this course use a flex or a grid just to lay out a handful of elements inside a div or a section.

### Understanding Flow vs Grid vs Flex 

There's a lot of overlap between flex and grid; they share many of the same concepts and use the same syntax for properties like `gap`. The fundamental difference between them is that **flex always tries to fill the container**, whereas **grid always respects rows and columns**.

From time to time, somebody will ask online "I'm using CSS flexbox with wrap; how do I stop the last item stretching to fill the row?" and the answer comes back "use a CSS grid":

{% iframe flow-vs-grid-vs-flex.html %}

## Basic CSS Grid Properties

CSS grid is a great example of a feature which is actually pretty simple, but which supports so many different property and shorthand syntaxes that it ends up seeming way more complicated than it really is.

Like flexbox, grid is based on the idea of a container element which contains a number of items. A CSS grid is fundamentally defined by two things.

First, the grid itself: how many rows and columns, and -- optionally -- the widths of the columns and the heights of the rows. Rows and columns are collectively known as *tracks*, so  *track size refers to either a row height or a column width depending on the context.

Second: how items should be placed in the grid. Do we fill each row and then move down to the next row, or fill each column and then move across to the next column -- and what happens when we run out of space?

If we just take an element like a `<div> and say "hey, that's a grid", it looks like nothing happens - because the default grid works exactly like the flow model; items take up the full width of the container, and we stack from the top downwards:

{% example default-grid.html elements="style" iframe %}

Using `grid-template-columns`, we can organise our grid into vertical columns by specifying the width of each column, using CSS absolute or relative units, or the special unit `fr`, denoting a fraction of the remaining available space.

> `fr` is officially short for for *fraction* but when I first saw it I thought "oh, OK, `fr` for 'free space'" and that's stuck in my head now. 

I've also added `padding: 10px` and `gap: 10px` here so you can see the arrangement of the grid items more clearly:

{% example grid-template-columns.html elements="style" iframe %}

If you only specify the columns, the browser's going to add as many rows as it needs to to accommodate all the grid items: use `grid-auto-rows` to specify the size of these rows. (If you specify more than one size, they'll be applied in order and then repeated)

{% example grid-auto-rows.html elements="style" iframe %}

Alternatively, you can flip the whole thing sideways. By specifying `grid-auto-flow: column`, we get a grid which fills from top to bottom, one column at a time, adding new columns as needed -- so we should also swap the other properties, so we're specifying `grid-template-rows` instead of `grid-template-columns` and `grid-auto-columns` instead of `grid-auto-rows`:

{% example grid-auto-flow.html elements="style" iframe %}

If you don't want an automatic grid layout, you can specify both the rows and columns:

{% example grid-template-rows-columns.html elements="style" iframe %}

If you look closely here, we're not actually giving any of the rows an explicit height; we've specified `grid-template-rows: 2fr 5fr 1fr`,  so where's the height coming from? The layout engine here is working backwards... it's making the bottom row big enough to contain its own content without clipping, and then going "right, if that's one fraction, then the middle row is five fractions, so five times larger, and the top row is two fractions so twice that height."

Note that a CSS grid will always create new tracks; if we specify a 3x3 grid and then give it ten child elements, it'll make a new track for the tenth item, although it will still respect the `grid-auto-flow` and `grid-auto-*` property when deciding where to create the extra track and what size it should be. You *can* specify the track size should be zero, but you'll still get an extra track, and it'll probably overflow its container because zero isn't big enough to contain it.

The final grid property is `grid-template-areas`, which takes a completely different approach to specifying a grid layout by letting us use a syntax similar to ASCII art to visually define the layout of our grid:

{% example grid-template-areas.html elements="style" iframe %}

What makes this syntax so powerful is that we can use it to define named grid areas; those areas can span more than one grid cell, and we can use the `grid-area` property on the items to place them in a named grid area:

{% example grid-template-areas-with-names.html elements="style" iframe %}

> The `.` here denotes a grid area with no name.

If you want to combine named areas with track sizes:

{% example grid-template-areas-with-track-sizes.html elements="style" iframe %}

## The `grid-template` Shorthand Syntax

If you don't want to specify areas, rows, and columns separately, you can use the shorthand `grid-template` property syntax: specify a row height after each list of area names, then a forward slash `/`, then the list of column widths:

{% example grid-template.html elements="style" iframe %}

You can even go a step further, because there's a `grid` shorthand property that accepts the `grid-template` syntax, so you can write the same rule as:

{% example grid-shorthand.html elements="style" iframe %}

OK, checkpoint. 

We've learned about six new CSS properties:

* `grid-auto-columns`
* `grid-auto-flow`
* `grid-auto-rows`
* `grid-template-areas`
* `grid-template-columns`
* `grid-template-rows`

In a moment, we're going to look at some other variants on the CSS grid syntax, but just about everything that is possible with CSS grid, you can achieve using the properties described above. Using the `grid-template` shorthand to define your layout in terms of named areas, and giving items a `grid-area` to position them within that layout, is friendly, readable, and covers 99% of the real-world use cases you'll ever see for CSS grid.

But if you want to get freaky? You want grid items that overlap, grids where the gaps between the tracks have got names, or grids inside other grids? Buckle up, buttercup. Let's see what else this thing can do.

## Advanced CSS Grid Syntax

The boundaries around the grid and between adjacent tracks are known as *grid lines* - and before you ask, there's no way to use CSS to make them visible the way you can with table cell borders.

<figure>
    <img src="./images/css-grid-lines.png" alt="CSS Grid Tracks">
    <figcaption>CSS grid: columns, rows, and lines</figcaption>
</figure>


If it helps, think of the grid cells like city blocks, and the lines as the streets between them. 

Items within the grid can target specific tracks using the `grid-column-start`, `grid-column-end`, `grid-row-start` and `grid-row-end` properties.

Something which often trips people up when they first encounter this syntax: we're not specifying the row or column number, we're specifying the *line between them*. I think one of the reasons there's so much confusion here is that there's some really misleading behaviour baked into the CSS grid spec. Take a look at this code and the resulting output:

{% example grid-start-end-edge-case.html elements="style" iframe %}

Div #1 - the red one - clearly starts and ends in column 3, and starts and ends in row 2... right?

No. This is actually invalid syntax. The numbers refer to lines, not rows/columns, so an item which starts *and ends* at column grid line 1 actually has zero width... but there's a fallback rule in the CSS grid spec which says that if the combination of a start and an end rule would create an element with zero (or negative) size, ignore the end rule... and because the default is to span a single row/column, it looks like it worked.

Here's an example that specifies start and end lines correctly. This example also creates some overlapping elements; these will be stacked in the order they appear in the HTML, unless you override this using a `z-index`:

{% example grid-item-start-end.html elements="style" iframe %}

## 







The rows and columns in a CSS grid layout are collectively known as *tracks*, so when you see a reference to a track or track size, we're talking about something which is either a row or a column.

<figure>
    <img src="./images/css-grid-tracks.png" alt="CSS Grid Tracks">
    <figcaption>CSS Grid Tracks</figcaption>
</figure>

The tracks in a grid are specified using the `grid-template-rows` and `grid-template-columns` properties; each property is a list of track sizes - absolute units, relative units, or the special `fr` unit which represents a proportion of the available space.

{% example grid-template-rows-and-columns.html elements="style" iframe %}

You can also use the `repeat` function to repeat the same track size:

{% example grid-template-rows-and-columns-repeat.html elements="style" iframe %}

## Explicit vs Implicit Grids

If there are more items in the grid than you've allocated spaces for, the grid layout module will add extra rows or columns to accommodate the extra elements.

By default, the grid layout adds additional rows to the end of the grid. 

>  These examples are interactive - click the button to add extra items to the grid:

{% example grid-implicit-rows.html elements="style" iframe %}

To add additional *columns*, add `grid-auto-flow: column` to the grid container; this tells the layout module to add elements by filling each column first, and adding more columns as needed:

{% example grid-implicit-columns.html mark_lines="11" elements="style" iframe %}

To control the size of the implicit tracks, use `grid-auto-rows` or `grid-auto-columns`:

{% example grid-auto-columns.html mark_lines="12" elements="style" iframe %}

## Named Tracks and Template Areas

Part of the power of CSS grid is the ability to name parts of the grid, and then use those names to allocate other elements in your document to named grid areas.

First up, let's take a look at named lines. To create a named line, put the name in `[]` square brackets between two tracks in the row or column template property.

* Remember, you aren't naming the tracks, you're **naming the lines between them**.

* A single line can have more than one name - useful when the end of one area also marks the start of another area, like when the `nav-end`

* A name can be applied to more than one line, and then used by qualifying it with a number - apparently useful if you put named lines into a `repeat()` statement.[^1]

[^1]: Don't ask me why anybody would do this. I have no idea.

{% example grid-named-columns.html elements="style" iframe %}

Naming lines is just a prelude to the really good stuff: named grid areas. You can take whole chunks of the grid, give them names using a relatively simple format, and then link chunks of content to those areas.

How simple? Imagine the dumbest thing you can possibly think of: ASCII art. Actually, even simpler than ASCII art, because there aren't any lines: just names. Given a 3x5 grid layout, we can divide into areas like this:

```css
div { 
	grid-template-areas: 
        "header     header    header"
        "site-nav  site-nav   adverts"
        "page-nav    main     adverts"
        "page-nav    main    comments"
        "footer     footer    footer";
}
```

The resulting layout ends up like this:

<figure>
    <img src="./images/css-grid-areas.png" alt="CSS Grid Tracks">
    <figcaption>CSS grid areas</figcaption>
</figure>

and then by specifying the `grid-area` property on the various elements that make up the page, we can lay those elements directly onto the grid:

{% example grid-named-areas.html elements="style" iframe_style="height: 600px;" %}

## Dense Grids

By default, a CSS grid always fills "forwards" --- items will be placed in the *next* available space, even if there's a blank space earlier in the grid which could accommodate them. To override this behaviour, set either the rows or columns to `auto-flow` and include the `dense` keyword:

{% example dense-grid.html elements="style" iframe %}

{% example dense-columns-grid.html elements="style" iframe %}

## Subgrid and Masonry Grids

As well as specifying track sizes, the CSS `grid-template-row` and `grid-template-column` properties can take the value `subgrid`

Subgrid is used when a grid item is itself a grid container; it causes the tracks and lines of the child element to align with the grid of the parent element. Other grid properties, like `gap`, are not inherited, and can be declared separately on the child container:

{% example subgrid.html elements="style,body" iframe %}

There's also a popular layout used on a lot of sites, most notably Pinterest, which is known as a *masonry layout*; a way to arrange irregular content in columns such that it doesn't leave any gaps:

<figure>
    <img src="./images/masonry-layout.png" alt="Masonry Layout">
    <figcaption>Example of a Masonry Layout</figcaption>
</figure>
There is a [proposal to add a masonry grid to CSS](https://css-tricks.com/css-masonry-css-grid/), so you could build a layout like the one above by specifying the grid columns as usual and setting `grid-template-rows` to `masonry`; however, at the time I'm writing this, it's only available as a technology preview in experimental versions of Safari, so I reckon it'll be mid-2026 at the earliest before we see any support across Chrome and/or Firefox for masonry grids; in the meantime, if you're trying to create this kind of layout, you'll have to get a bit creative.

## Grid Shorthand Syntaxes

OK, this is where it gets complicated... and maybe a little tedious. But the problem with covering something like CSS grid in this kind of course is that there's about a thousand different ways to write a CSS grid spec, so there's no telling which ones you might encounter out there in the wild when you're maintaining or modifying existing code that uses a CSS grid. We're not going to go through *all* the possible variants, but here's the ones to look out for.

### grid-template

First, there's a `grid-template` shorthand property for defining areas, rows, and columns. If you only specify the named areas, you'll get a completely auto-sized grid; you can also specify the height of each row alongside the row definition, and if you want to specify the column widths as well, put a slash after the grid areas and list the column track sizes there:

{% example grid-template-shorthand.html elements="style" iframe %}

### grid

There's also the `grid` shorthand property, which covers al the possible grid properties and --- confusingly --- also lets you use the `grid-template` syntax as part of the shorthand.

* 

Like most CSS shorthand properties, it's redundant if you're only specifying a single property, useful if you're specifying two or three properties, and rapidly becomes unreadable if you pack in many more than that.

Here's the deal. If `grid` starts with a quoted string, then it's the shorthand version of the grid template areas syntax:

{% example grid-shorthand-with-areas.html elements="style" %}

If it starts with anything else, it's the other version.











## Justify, Align, and Grid Item Properties

Like CSS flexbox, grid gives us a whole range of options when it comes to aligning and justifying items in the container, and for allowing individual items to override container-level styling.

## References and Further Reading

I learned most of what I know about using CSS grid from Chris House's excellent [CSS Grid Layout Guide](https://css-tricks.com/snippets/css/complete-guide-grid/) over at css-tricks.com, which also has a [one-sheet quick-reference guide](https://css-tricks.com/wp-content/uploads/2022/02/css-grid-poster.png) covering all the grid layout properties and values.
