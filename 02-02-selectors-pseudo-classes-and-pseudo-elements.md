---
title: "Selectors, Pseudo-Classes and Pseudo-Elements"
layout: home
nav_order: 10202
word_count: 63
target_minutes: 20
---
One of the most important principles in software engineering is known as the *separation of concerns*. You shouldn't mix, say, database queries and tax calculations in the same function, for a whole raft of reasons -- not least that you shouldn't have to connect to a database to be able to test your code calculates taxes correctly.

As we talked about earlier in the course, separation of concerns in frontend web development is about separating content, presentation, and behaviour. HTML should focus on the **structure** of the content - what does it mean? What are the elements that make up a page, and what are the relationships between those elements? CSS then gives us the tools to interrogate that structure and apply colours, fonts, borders, and other visual elements to make that structure more apparent to humans. Got a bunch of links that belong together? Use HTML to group them using a list or a menu element, then use the CSS to draw a border around it.

The key to doing this is being able to target the elements you want to style --- and, in some cases, dynamically add new elements to the page during rendering. We've already learned about CSS selectors based on elements, class names, and element IDs; let's meet the rest of the CSS selector family, and their cousins, the pseudo-classes and pseudo-elements.

First, let's remind ourselves what we're trying to accomplish here.

Here's some bad HTML:

{% example bad-html.html %}

It's not *wrong* - there aren't any syntax errors or invalid tags - but I don't like it at all.

* Class names are based on what we want the element to *look like*, not on w

# Selectors, Pseudo-Classes and Pseudo-Elements (20m)

## Course Content

- Combinators: `A > B`, `A + B`, `A ~ B`, `A || B` *(draft)*
- State selectors: `:link`, `:visited`, `:active`, `:hover`, `:focus`
- Attribute selectors: `=-=`, `~=`, `|=`, `^=`, `$=`, `*=`
- Structural selectors: `:first-child`, `:last-child`, `:only-child`, `:nth-child(n)`, `:nth-last-child(n)`, `:first-of-type`, `:last-of-type`, `:only-of-type`, `:nth-of-type(n)`, `:nth-last-of-type(n)`, `:empty`
- Match selectors: `:not()`, `:is()`, `:where()`, `:has()`
- Pseudo-elements: `::first-line`, `::first-letter`, `::before`, `::after`, `::placeholder`, `::marker`, `::selection`
- using `attr()` in `content`
- Exercise: Building a CSS mosaic

## Notes











