---
title: "Selectors, Pseudo-Classes and Pseudo-Elements"
layout: home
nav_order: 204
word_count: 1456
target_minutes: 20
examples: examples/204-selectors-pseudo-classes-and-pseudo-elements
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

## Location Pseudo-classes

Web pages are interactive. Users click on links, fill out forms --- even just moving the mouse around the screen can be a form of interaction.

Now, in theory, this is all nice & simple. Everything's a `:link` until something happens. If you move the focus to that element - e.g. using the <kbd>Tab</kbd> key on your keyboard - it gets the `:focus` pseudo-class. When you hover over it, it gets the `:hover` pseudo-class; when you're actually clicking it, it gets the `:active` pseudo-class, and then any link to a page you've visited before gets the `:visited` pseudo-class.

In practice... it's way more complicated than that. Hover states work great on devices with a mouse pointer, but on touchscreen devices like smartphone and tablets, you can't hover or focus an element - you're either touching it, or you're not.

In this example, each side of the border responds to a different pseudo-class, and the background-color responds to the `:active` state:		

{% example state-selectors.html %}

If we tab around using the keyboard, you'll see the focus move to each link in turn; if we move the mouse over an element, we get the hover pseudo-class; if we click on it, it goes active, and then when we come back to the page, it doesn't have the `:link` pseudo-class any more, it has the `:visited` pseudo-class.

Now, let's open that same page on a smartphone. You'll notice that links on a mobile device never get the focus, although we can focus the `<input>` element; elements will briefly get the `active` state when we click them, but because by that point we're already navigating away, there's not a whole lot you can do with it.

There are a whole bunch more pseudo-classes which only apply to inputs and form elements, which we'll learn about in part 3, but one more location pseudo-class that's worth knowing about is the `:target` selector.

URLs can contain what's known as a `fragment`; it always appears right at the end of the URL, preceded by a `#` character, and it says to the browser "hey, load this page, and once it's loaded, please find the element with this ID, and scroll it into view". For example, this URL will open the MDN documentation for the `:target` pseudo-class, and jump to the **Description** section:

* [`https://developer.mozilla.org/en-US/docs/Web/CSS/:target#description`](`https://developer.mozilla.org/en-US/docs/Web/CSS/:target#description`)

Using the `:target` pseudo-class, we can apply specific styles to the element that matches the current URL fragment, which can be really useful for navigation, or for highlighting a user's journey through some kind of step-by-step process:

{% example target-pseudo-class.html %}

## Attribute Selectors

If you've ever used XSLT to transform XML documents, then (1) you have my sympathies, and (2) you're going to find this next part very familiar.

Let's learn about CSS attribute selectors.

Say we've got a page containing a bunch of links, and we want all the links that go to Wikipedia to be highlighted in blue, and all the links to TV Tropes to be highlighted in red so we know not to click them or we'll end up browsing TV Tropes for the rest of the day. Any other links can stay plain blue on white.

Attribute selectors give us a way to target elements based on the contents of their HTML attribute values.

We'll start with the useful ones.

|      | Syntax                            | Matches                                                      |
| ---- | --------------------------------- | ------------------------------------------------------------ |
|      | `a[title]`                        | Any `a` element with a `title` attribute (even if it's empty!) |
| `=`  | `a[href="https://google.com"]`    | Any `a` element whose `href` attribute **exactly matches** `"https://google.com"` |
| `*=` | `a[href*="wikipedia"]`            | Any `a` element whose `href` attribute contains `"wikipedia"` |
| `^=` | `a[href^="https://tvtropes.org"]` | Any `a` element whose `href` starts with `"https://tvtropes.org"` |

{% example attribute-selectors-1.html iframe_style="height: 15em;" %}

But hang on - that last link there, to the TV Tropes page about Wikipedia? That link's `href` attribute is `"https://tvtropes.org/pmwiki/pmwiki.php/Website/Wikipedia"`, which definitely contains `"wikipedia"`, so why is it red rather than blue?

Two reasons. First: attribute selectors, like class names and IDs, are *case sensitive* - so that's not going to match because our CSS rule is looking for `"wikipedia"` but the actual `href` is `"https://tvtropes.org/pmwiki/pmwiki.php/Website/Wikipedia"` --- capital “W” ---  so it won't match. Good news is that's an easy fix - add an `i` inside the `[ ]` for the selector rule:

```css
a[href*="wikipedia" i] {
    background-color: blue;
    color: white;
}
```

Now, we have two rules: one says if the `href` starts with `"https://tvtropes.org"`, the link is red; the other says if the `href` contains `"wikipedia"` -- case insensitive -- the link is blue. So which rule wins?

The short answer is: the last one. Last one wins.





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











