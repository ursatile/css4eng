<<<<<<< HEAD:208-lists-and-counters/index.md
---
layout: home
nav_order: 208
target_minutes: 5
title: "Lists and Counters"
word_count: 539
---
HTML defines three different elements we can use to create lists.

**Unordered lists**, denoted by `<ul>` with the item tag `<li>`, are for lists with no intrinsic order - like the musicians in a band; as long as they're all there, the order doesn't really matter.

{% example unordered-list.html elements="body" iframe_style="" %}

**Ordered lists,** denoted by the tag `<ol>` and the item tag `<li>`, denote items with a meaningful order, such as the track listing on a record:

{% example ordered-list.html elements="body" iframe_style="" %}

And **description lists** (which were called *definition lists* until HTML5, since they were originally intended for marking up content like dictionaries and glossaries) - a `<dl>`  containing *description term* `<dt>` elements, each with an associated *description details* `<dd>`:

{% example description-list.html elements="body" iframe_style="" %}

## Styling Lists

Let's start with the easy ones. You want to change the style of the bullets used on an unordered list? There's a bunch of built-in bullets you can use:

{% example list-style-type.html elements="style,body" iframe_style=""%}

If you want the bullets to appear inside the element's content, instead of alongside it, use `list-style-position`:

{% example list-style-position.html elements="style,body"  iframe_style=""%}

This screenshot shows how the list markers are actually drawn into the left padding on the `<ul>` element:

![list-style-position and padding](./images/list-style-position-padding.png)

To style the marker itself, CSS exposes the `::marker` pseudo-element:

{% example marker-pseudo-element.html elements="style,body" iframe %}

## Defining Custom Counters with `@counter-style`

The `@counter-style` rule, available across all mainstream browsers since 2023, provides a way to define our own custom counter styles.

It's incredibly powerful and flexible; check out the [MDN documentation](https://developer.mozilla.org/en-US/docs/Web/CSS/@counter-style) for full details of how `@counter-style` works; here's a few examples to give you some idea of what it can do.

{% example counter-style.html elements="style,body" iframe %}

The thing to remember about an unordered list is that, while the browser typically displays it as a list of bullet points, it doesn't have to be bullets. One very common scenario is to wrap a `<ul>` inside a `<nav>` element, to create the main navigation menu for a page or a site:

{% example nav-ul-li.html elements="style,body" iframe %}

## CSS Counter Functions

As well as using lists for elements like menus, we can use CSS counters for things which aren't lists.

* `counter-reset` and `counter-increment` will modify the value of a named counter
* Using pseudo-elements, `content` and the `counter()` function, we can add counters to elements during the styling process.

### Custom Identifiers in CSS

Counter names are the first example we've met of a property which uses a CSS [custom identifier](https://developer.mozilla.org/en-US/docs/Web/CSS/custom-ident) (aka *custom-ident*). Custom identifiers must be:

* one or more more characters, containing letters  `A-Za-z`, digits `0-9`, hyphens `-` and underscores `_`. 
* Other characters, and Unicode code point sequences, must be escaped with a backslash `\`
* Custom idents can't start with a number; if they start with a hyphen, the first non-hyphen character must not be a number.

Valid custom identifiers:

* `valid-identifier`
* `-valid-identifier`
* `_valid_identifier`
* `-my-id-123`
* `my\.identifier` (period escaped with a backslash)

Invalid identifiers:

* `123-identifier` (starts with a digit)
* `-123-identifier` (starts with a hyphen followed by a digit)
* `my.identifier` (the `.` hasn't been correctly escaped)
* `my identier` (custom idents can't contain spaces)
* `'my identifier'` (idents can't be quoted strings)

For example, to create a document with legal-style numbered paragraphs, we can define custom counters called `section`, `subsection` and `paragraph`, which we then increment and reset based on the document structure:

{% example counter-content.html elements="style,body" iframe_style="height: 20em;" %}

=======
---
examples: examples/208-lists-and-counters
layout: home
nav_order: 208
target_minutes: 5
title: "Lists and Counters"
word_count: 539
---
HTML defines three different elements we can use to create lists.

**Unordered lists**, denoted by `<ul>` with the item tag `<li>`, are for lists with no intrinsic order - like the musicians in a band; as long as they're all there, the order doesn't really matter.

{% example unordered-list.html elements="body" iframe_style="" %}

**Ordered lists,** denoted by the tag `<ol>` and the item tag `<li>`, denote items with a meaningful order, such as the track listing on a record:

{% example ordered-list.html elements="body" iframe_style="" %}

And **description lists** (which were called *definition lists* until HTML5, since they were originally intended for marking up content like dictionaries and glossaries) - a `<dl>`  containing *description term* `<dt>` elements, each with an associated *description details* `<dd>`:

{% example description-list.html elements="body" iframe_style="" %}

## Styling Lists

Let's start with the easy ones. You want to change the style of the bullets used on an unordered list? There's a bunch of built-in bullets you can use:

{% example list-style-type.html elements="style,body" iframe_style=""%}

If you want the bullets to appear inside the element's content, instead of alongside it, use `list-style-position`:

{% example list-style-position.html elements="style,body"  iframe_style=""%}

This screenshot shows how the list markers are actually drawn into the left padding on the `<ul>` element:

![list-style-position and padding](./images/list-style-position-padding.png)

To style the marker itself, CSS exposes the `::marker` pseudo-element:

{% example marker-pseudo-element.html elements="style,body" iframe %}

## Defining Custom Counters with `@counter-style`

The `@counter-style` rule, available across all mainstream browsers since 2023, provides a way to define our own custom counter styles.

It's incredibly powerful and flexible; check out the [MDN documentation](https://developer.mozilla.org/en-US/docs/Web/CSS/@counter-style) for full details of how `@counter-style` works; here's a few examples to give you some idea of what it can do.

{% example counter-style.html elements="style,body" iframe %}

The thing to remember about an unordered list is that, while the browser typically displays it as a list of bullet points, it doesn't have to be bullets. One very common scenario is to wrap a `<ul>` inside a `<nav>` element, to create the main navigation menu for a page or a site:

{% example nav-ul-li.html elements="style,body" iframe %}

## CSS Counter Functions

As well as using lists for elements like menus, we can use CSS counters for things which aren't lists.

* `counter-reset` and `counter-increment` will modify the value of a named counter
* Using pseudo-elements, `content` and the `counter()` function, we can add counters to elements during the styling process.

### Custom Identifiers in CSS

Counter names are the first example we've met of a property which uses a CSS [custom identifier](https://developer.mozilla.org/en-US/docs/Web/CSS/custom-ident) (aka *custom-ident*). Custom identifiers must be:

* one or more more characters, containing letters  `A-Za-z`, digits `0-9`, hyphens `-` and underscores `_`. 
* Other characters, and Unicode code point sequences, must be escaped with a backslash `\`
* Custom idents can't start with a number; if they start with a hyphen, the first non-hyphen character must not be a number.

Valid custom identifiers:

* `valid-identifier`
* `-valid-identifier`
* `_valid_identifier`
* `-my-id-123`
* `my\.identifier` (period escaped with a backslash)

Invalid identifiers:

* `123-identifier` (starts with a digit)
* `-123-identifier` (starts with a hyphen followed by a digit)
* `my.identifier` (the `.` hasn't been correctly escaped)
* `my identier` (custom idents can't contain spaces)
* `'my identifier'` (idents can't be quoted strings)

For example, to create a document with legal-style numbered paragraphs, we can define custom counters called `section`, `subsection` and `paragraph`, which we then increment and reset based on the document structure:

{% example counter-content.html elements="style,body" iframe_style="height: 20em;" %}

>>>>>>> 11c62976dce45c47dbb069f9a3901d41e6923bac:208-lists-and-counters.md
