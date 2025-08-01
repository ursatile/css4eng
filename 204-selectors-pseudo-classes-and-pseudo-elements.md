---
title: "Selectors, Pseudo-Classes and Pseudo-Elements"
layout: home
nav_order: 204
word_count: 2107
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

In this example, each side of the border responds to a different pseudo-class, and the background-colour responds to the `:active` state:		

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

Attribute selectors give us a way to target elements based on the contents of their HTML attribute values.

Let's say we've got a page about TV shows, containing a bunch of links, and we want to highlight links based on where they go.

{% example attribute-selectors-1.html %}

The requirements are:

* Links with a title attribute should be in italics
* Links to the exact URL `"https://startrek.com/"` should be highlighted in `skyblue`
* Links to any page on TV Tropes should be highlighted in `pink`
* Links that go to Wikipedia should be highlighted in `palegreen`

First, create in a rule that'll match any link with a title attribute:

```css
a[title] { 
    font-style: italic; 
}
```

Next, a rule that'll match the `href` property exactly:

```css
a[href="https://startrek.com/"] { 
    background-color: skyblue;
}
```

Match any link whose `href` attribute *starts with* `"https://tvtropes.org/"` - if you know regular expressions, you'll recognise the caret `^` meaning "match the start":

```css
a[href^="https://tvtropes.org"] { 
    background-color: pink;
}
```

And finally, any link whose `href` *contains* the text `"wikipedia"`:

```css
a[href*="wikipedia"] { 
    background-color: palegreen; 
}
```

{% iframe attribute-selectors-1-complete.html style="height: 200px;" %}

Hang on, though... there's a link to the TV Tropes page for Mysterious Cities of Gold there, and it's not pink. We might click it by mistake! But - if you take a close look at that link, and you'll se that the domain name is uppercase. Somebody's linked to `TVTROPES.ORG` instead of `tvtropes.org` --- and the `href` attribute value in HTML is *case sensitive*. Fortunately, there's an easy fix - add an `i` (for *insensitive) inside* the `[ ]` for the selector rule:

```css
a[href^="https://tvtropes.org" i] {
    background-color: pink;
}
```

Case sensitivity for attribute selectors is complicated. The type selector - the element name - and the attribute name are always case-insensitive, but the attribute value in HTML is case sensitive, *unless* it's one of the [46 special cases defined in the HTML living standard](https://html.spec.whatwg.org/multipage/semantics-other.html#case-sensitivity-of-selectors). As we just learned, if you need to make a rule case-insensitive, you can add an `i` to the selector rule, and if you need to override the default for one of those 46 special cases, you can add an `s` to the selector rule.

We need three more attribute selectors to collect the whole set.

First, the `$=` operator, which will match the *end* of an attribute value. For example, we could use this to add a `background-color` property to any image on our site which is in `.png` format:

{% example attribute-match-pngs.html iframe_style="height: 10em;" %}

Next up, there's the `~=` operator, which will match any word that appears in the attribute value. This one's a little more esoteric, but say we had a list of employees on our intranet, and each employee's element had an HTML `data-job-roles` attribute listing all the things that employee's qualified to do, and we wanted to highlight the people with First Aid training:

{% example attribute-job-roles.html iframe_style="height: 10em;" %}

Finally, there's the `|=` operator. This one's even more specialised: it'll match any attribute value, or the first part of an attribute value if the value's followed by a hyphen. It's designed specifically to match ISO language codes, as in this example:

{% example attribute-iso-lang-codes.html iframe_style="height: 20em;" %}

## Structural Selectors

Structural selectors match elements based on the structure of the document. Hence the name.

You want to highlight the first item in a list? Use the `:first-child` selector.

```css
ul :first-child { color: royalblue; }
```

You want to highlight the first element in a `section`, but only if it's an `h2`? You can combine type selectors with structural selectors:

```css
section h2:first-child { color: red; }
```

Say we wanted to put a bottom border on every paragraph except the last one in a section - with structural selectors, that's easy; we put a bottom border on every paragraph, and then use the `:last-child` selector to remove it from the last one:

{% example last-child.html iframe_height="20em" %}

> Notice that we've used a nested CSS rule there, and the actual selector syntax is `&:last-child`? The `&` there is used to combine the enclosing rule with an additional selector - the rule says "hey, apply these rules to *all* paragraphs -- and if one of those paragraphs is a last-child, then also apply these extra rules"

There's also the `:only-child` selector, which you can use to find lonely elements with no brothers and sisters:

{% example only-child.html iframe_height="20em" only_lines="6-8" iframe_style="height: 15em;" %}

### nth-child selectors

One scenario I've encountered countless times in my own career is *zebra striping* - shading alternate rows of a table to improve readability. The CSS nth-child selectors make this kind of thing really straightforward: they'll target elements based on their index, and they support various formulae you can use to target repeating elements.

The classic zebra-stripe table example uses `:nth-child(even)`:

{% example zebra-stripes.html iframe_height="20em" start_after="<style>" end_before="</style>" iframe_style="height: 15em;" %} 

but you can also stripe `:nth-child(3n)` to target every third row, `:nth-last-child(odd)` to target odd-numbered rows starting from the end and working backwards, `:nth-child(3n+7)` to target the seventh row and every third row thereafter...

### of-type selectors

OK, but what if you want to, say alternate the images in a section, so they float left, then right, then left, even if there are other elements between them? Or you want a special rule to apply to an image if it's the only image in that section, even if the section also includes paragraphs and lists and other elements?

That's what the `of-type` selectors are for.

{% example of-type.html iframe_height="20em" start_after="/* begin examples of of-type selectors */" end_before="/* end examples of of-type selectors */" iframe_style="height: 15em;" %} 

The final structure selector is `:empty`, which -- you guessed it -- matches an element with no content. The only scenario I've seen this used in is a content management system - CMS - based on Markdown, which would translate empty lines into empty paragraphs, so you'd end up with a bunch of empty paragraphs on the page; by using an `:empty` selector , we could set them to `display: none` so they'd disappear completely:

{% example empty.html iframe_height="20em" start_after="/* begin examples of of-type selectors */" end_before="/* end examples of of-type selectors */" iframe_style="height: 8em;" %} 

## Match Selectors

OK, scenario - we want to put a border around any section which contains exactly one image. If a section contains more than one image? No border. If a section contains no images? No border.

None of the selectors we've seen so far can do this - we can find the *image*, sure, but then we don't have any way to step back up the DOM tree and apply a style to the parent element.

Let's meet a new selector: `:has()`

{% example selector-has.html iframe_style="height: 20em;" %}

`:has()` is one of the CSS *match selectors*, along with `:is()`, `:where()` and `:not()`

At a glance, `:is()` looks kinda useless:

```css
:is(p) {
    /* style for paragraph */
}
```

but what makes it so powerful is being able to build rules that use multiple selectors as part of a composite selector. For example, say we want `h1` and `h2` elements to be purple, with a red bottom border, but *only if they are the first child element of a section, or an article, or a main element.*

Using normal selectors, we'd have to write a rule like:

```css 
section h1:first-child, 
section h2:first-child,
article h1:first-child,
article h2:first-child,
main h1:first-child,
main h2:first-child {
    color: purple;
}
```

Using the `:is()` selector, we can write the same rule much more succinctly:

{% example is-selector.html iframe_style="height: 20em;"  start_after="<style>" end_before="</style>" %}

`:where()` has exactly the same behaviour as `:is()`, apart from one very important distinction: it doesn't affect the specificity of the rule.

{% example where-vs-is.html %}

Finally, there's the `:not()` selector, sometimes called the *negation pseudoclass*. This one can be really useful, but it can also do all kinds of weird stuff.

Earlier, we saw an example of using the `:last-child` selector to remove a border from the last paragraph on a page --- but a much nicer way to achieve the same thing is to use a `:not()` selector so that the border never gets applied in the first place:

{% example not-selector.html elements="style,section" %}

You can use `:not()` to crank up the specificity of rules by filtering for non-existent elements:

```css
p#horse { 
    /* 1-0-0 */ 
}

p#horse:not(#unicorn):not(#pegasus):not(#centaur) {
    /* 4-0-0, because there are four IDs in the selector rule */
}
```

You can also write completely nonsensical rules using `:not()`. `p:not(p)` matches every paragraph which isn't a paragraph, and `not(.foo)` matches every single element on the page which doesn't have the `"foo"` class -- which includes `<html>`, `<body>` , and will even match elements which are ordinarily invisible like `<head>`, `<style>`, and `<meta>` tags:

{% example not-foo.html %}

## Selector Strategies

One of the most powerful principles in software engineering is to do the simplest thing that solves the problem you have right now. The road to development hell is paved with good ideas, abstractions, frameworks, and things which looked like they might be useful later.

As far as CSS selectors are concerned: try to use the fewest, simplest selector rules you possibly can. Target HTML elements based on document structure, rather than adding classes and IDs just so you can target something with a CSS rule. If your site's basic CSS is built around types and structural selectors, you're going to find it much easier when you have to implement a special case.

If you need to style different kinds of page within the same application, see if you can do it using a single class on the `<html>` or the `<body>` element, and building rules which cascade down from there, instead of adding classes all over the page.

We'll come back to selector strategies and the architecture of CSS in part 3 of the course, when we talk about building complex interactive applications for the web.

## CSS Pseudo-Elements

Pseudo-elements give us a way to target a specific part of an element's content. The classic example is using `::first-line` and ``:first-letter` to style up a paragraph of text with a decorative capital initial. You can also use the `::selection` pseudo-element to target the part of the document that's been selected (e.g. by dragging over it with the mouse) - try highlighting part of this excerpt from Dickens' "A Tale of Two Cities":

{% example first-letter-first-line.html iframe_style="height: 10em" elements="style, body" %}

> The only properties that can be styled with `::selection` are `color`, `background-color`, `text-decoration` and `text-shadow`. You can't use `::selection` for anything that could affect the document's layout, otherwise you end up with text that moves out of the way when you try to click on it, which makes for a truly terrible user experience.

`::marker` can be used to style the bullets and numbers on HTML lists --- we've got a whole dedicated section about lists and counters coming up, but as far as the selector syntax goes, it works like this:

{% example marker-pseudo-element.html %}

Then there's `::placeholder`, which we can use to style the placeholder text which appears in certain kinds of form elements when the user hasn't entered any data yet:

{% example placeholder-pseudo-element.html elements="style, body" iframe_style="height: 5em;" %}

And then there are the two pseudo-elements which aren't really elements at all... but which you can use to do all kinds of awesome things. They're the `::before` and `::after` pseudo-elements, and they're a little strange because, by default, they don't exist.

But... CSS defines a property called `content`, which we can use to inject content into the page as part of the the styling process. The content can't be HTML - markup isn't support - but it can be text, including Unicode text --- which means we can use emoji --- or it can load an external image.

{% example before-and-after-pseudo-elements.html %}

- Pseudo-elements: `::before`, `::after`, `::placeholder`, `::marker`, `::selection`
- using `attr()` in `content`
- Exercise: Building a CSS mosaic

## Notes











