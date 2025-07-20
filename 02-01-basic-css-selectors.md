---
title: "Basic CSS Selectors"
layout: home
nav_order: 10201
examples: examples/02-01-basic-css-selectors
---

So far, we've learned about the building blocks of the CSS language - selectors, properties, and values - and the tools and techniques we can use to inspect and manipulate those properties.

In the last section, we saw that we can use properties like `outline` and `background-color` to highlight specific elements in our document, making it easier to debug and troubleshoot our CSS layouts - but so far, we've only created rules that target a specific element: h1, paragraph, emphasis.

Let's learn about a few of the other selectors we can use to target elements on our pages.

### The Wildcard Selector `*`

The `*` character means "match everything". To give every single element on our page a red outline, we can say:

```css
* {
    outline: 1px solid red;
}
```

### Element Selectors

As we've already seen, if a selector exactly matches an HTML element's tag name, it'll target all elements of that type:

```css
p { /* applies to all paragraphs */
    color: blue;
}
h1 { /* applies to all level 1 headings */
    color: red;
}
```

### Class Selectors

HTML supports the `class` attribute, which we can add to any element on the page. Elements can have multiple classes, and CSS can target elements based on their class attribute using the `.className` syntax:

```html
```







- Basic selectors:`*`, element, className, id
- Combinators: `A B`, `A > B`, `A + B`, `A ~ B`, `A || B` *(draft)*
- nested selectors
