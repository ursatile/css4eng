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

It's not *wrong* - there aren't any syntax errors or invalid tags - but I don't like it at all. Class names are based on what we want the element to *look like*, not on what it *means*. Imagine a ticket comes in asking you to change all the green headings to be purple... you *could* change the name of the rule, and then go trawling through the code doing a global search & replace, replace `green` with `purple`, but it's easier --- and safer --- to just rewrite the rule...

```css
h1.green {
	color: purple;
}
```

...and now you've got a rule on your website that says all the green headings should be purple. Great work.

Compare that to this:

{% example less-bad-html.html %}

The class names here aren't based on what the element should *look like*, they're based on where that element appears in the structure - and then the CSS uses that information to style them according to our requirements.

But, other than the `section` being given the `promotion` class, most of the class names here aren't actually communicating anything that we can't infer  from the document structure itself. The browser can't tell that this page is some sort of product promotion unless we add a class name, but it can absolutely tell that this `h1` is the first element in a section, that there's a series of paragraphs immediately after it, and so on.

Using modern CSS, we can target elements based on their relationships without having to use extraneous class names. Let's find out how.

## Combinators

We've already met the *descendant combinator*, which is just a space between two selectors:

* `p a { }` - match any `a` element which is a descendant of a `p` element.
* `main .highlight { }` - matches any element with a `highlight` class which is a descendant of a `main` element
* `.promo #call-to-action` - matches the element with the ID `call-to-action`, but only when that element is a descendant of an element with a `promo` class.

There are four more combinators you should know about.

* **Child combinator**, indicated by a greater-than character `>`. `p > a` matches any `a` element which is a *direct child* of a `p` element
* **Subsequent sibling combinator** indicated by a tilde `~`. `h3 ~ p` matches *every* paragraph that occurs anywhere following an `h3` element, as long as they share a parent.
* **Next-sibling combinator** indicated by a plus `+`. `h3 + p` matches a single `p` which is immediately preceded by an `h3`, and shares the same parent.

> CSS also supports the **column combinator** `||`, which we'll talk about in the section about styling tables and tabular data.

{% example combinators.html mark_lines="3,5,7,9" iframe_style="height: 18em;"  %}

## State Selectors

Web pages are interactive. Users click on links, fill out forms --- even just moving the mouse around the screen can be a form of interaction. 

{% example state-selectors.html %}

Let's start with the easy one: `:active`







Using **state selectors**, CSS can target elements based on what's happening to them right now. State selectors are usually applied to elements we're expecting the user to click on, like `<a>` and `<button>`

* `:hover` matches an element the user's pointer is hovering over. 

  **Watch out for touchscreen devices.** If you're building interaction for smartphones or tablets, don't rely on `:hover` to do anything important.

* `:active` matches an element that's actually being clicked on right now.

* `:visited` matches an element that's previously been clicked

* `:focus` matches an element that has the *focus*. 

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











