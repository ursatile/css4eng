---
title: "Basic CSS Selectors"
layout: home
nav_order: 10201
examples: examples/02-01-basic-css-selectors
word_count: 1538
target_minutes: 10
---
So far, we've learned about the building blocks of the CSS language - selectors, properties, and values - and the tools and techniques we can use to inspect and manipulate those properties.

In the last section, we saw that we can use properties like `outline` and `background-color` to highlight specific elements in our document, making it easier to debug and troubleshoot our CSS layouts - but so far, we've only created rules that target a specific element: h1, paragraph, emphasis.

CSS selectors give us an incredibly powerful mechanism to control which elements are affected by our stylesheet rules, but they do have a bit of a learning curve. Let's start by talking about what selectors actually do.

## The House Party Dress Code

Imagine there's a whole bunch of people at a house party, and our job is to make sure they're all properly dressed. It's a very special party - everybody here is either a pilot, a lawyer, a doctor, or a musician. Every guest has exactly one job, and there's a very specific dress code for this party:

1. everybody must wear blue jeans
2. musicians must wear black T-shirts
3. people who own cats must wear purple hats
4. Freddie Mercury must wear a yellow jacket

To translate that into terms of CSS: everybody at the party is an element. All of them. If we want to target everything on the page, we can use the wildcard selector `*`

Musicians in our example are a particular type of person; this is analogous to targeting a particular type of HTML element, such as a paragraph. Every HTML element has exactly one type: you can't have a paragraph which is also a button. We've already seen how to target elements based on their type, using the associated tag name as the selector.

Cat owners are a particular *class* of person. Somebody owns a cat, or they don't -- and it doesn't matter what job they have. Anybody can own a cat. It's also not mutually exclusive - somebody can can own a cat, and ride a motorbike, and like to watch hockey - and there could be more than one cat owner at the party.

We have classes in HTML as well - any HTML element can have a `class` attribute, which can contain one or more class names. Class names aren't part of HTML - you choose your own class names to suit your scenario, and a class name can be anything you like, as long as it starts with a letter, and contains only letters, numbers, underscores and hyphens.

The key thing about classes is that they have a many-to-many relationship to elements. One element can have multiple classes, and a class can be used many times on the same page.

Finally, there's Freddie Mercury. That's an *identity* - Freddie's unique; you can't have more than one Freddie. And a person can't have more than one identity - Freddie can't also be Taylor Swift.

HTML elements can have an identity too - it's defined by their `id` attribute. Like class names, IDs are up to you; you should choose IDs that are relevant to your scenario. An element doesn't need to have an ID, but it can't have more than one - and you should never have two elements with the same ID on the same page.

Now, students of rock'n'roll trivia will know that Freddie Mercury is also a musician - and that he owned cats. So if Freddie was an HTML element, he'd look like this:

`<musician id="freddie-mercury" class="cat-owner">`

and when we apply all our CSS rules, Freddie gets blue jeans because everybody gets blue jeans, a black T-shirt 'cos he's a musician, a purple cat because he's a cat lover, and a yellow jacket because he's Freddie Mercury.

## Wildcards, Elements, Classes and IDs

Switching from house parties back to HTML, let's take a look at an example of a page that uses all of these concepts:

* [ToastMaster 9000 Instruction Manual]({{ page.examples }}/toastmaster-9000.html)

```html
{% include_relative {{ page.examples }}/toastmaster-9000.html %}
```

First up, we've got a wildcard rule here to make everything on the page navy.

Next, we target the heading level 1 with an element rule, to give it white text on a navy background. We've got a `warning` class that makes things white on a red background, a `disclaimer` class that turns text `gainsboro` - a very, very pale shade of grey - and finally an ID selector: exactly one element on this page will be the `features` panel for our toaster, and we'd like to draw that in dark green on a pale green background.

> ℹ️ HTML is generally case-insensitive, but CSS class names and IDs are not: your class names and element IDs have to exactly match your CSS selectors, including their case. An element with `<p

Now, you see how the word "warning" and "caution" is in navy blue here, despite being part of a warning paragraph? We actually have two conflicting rules here. One is the wildcard rule - hey, everything on this page should be navy blue, unless something overrides it. The other is saying “hey, stuff inside warning paragraphs should be white with a red background”.

Those strong tags pick up the red background, because there's no other rule that would affect their background colour - but the wildcard rule here applies to **every element**, and so it takes precedence over the white text rule, which is inherited from the warning paragraph.

So, let's change it. Edit that rule so instead of the wildcard selector, it targets the HTML `<body>` element:

```css
body {
	color: navy;
}
```

The page looks the same - except those "warning" and "caution" elements are white now. The reason is **cascading**. We've said "everything in the body should be navy", and that rule cascades down... but then when we get to the warning paragraph, that sets a rule that everything should be white, and that second rule wins. The first rule has to cascade from the body element, to the warning paragraph element, to the strong element; the second rule only has to cascade from the warning paragraph to the strong, and shorter cascades are more specific, and therefore have a higher precedence.



We're going to come back to selectors shortly, because they are phenomenally powerful. To go back to house party example: we could have a rule for anybody who's standing in the kitchen, a different rule for somebody standing in the kitchen who has a cat, a rule that only applies to a pilot who is standing next to a doctor, a rule that only applies to the first doctor in a room... we can combine selectors in all sorts of combinations and permutations.

For now, there are two more combinations I want to show you before we move on.

## Grouped and Nested Selectors

First, you can have a rule with multiple selectors by separating them with commas, known as a *list selector* or *selector group*. Here's a rule that'll apply to every heading style in a document:

```css
h1, h2, h3, h4, h5, h6 {
    color: green;
}
```

Second: CSS has also always supported something called *descendant combinators*. The relationships between elements on a page are often described using terms from genealogy; take a look at this example:

```html
<article>
    <h1>This is a heading</h1>
    <h2>This is a sub-heading</h2>
    <p>This is a paragraph containing a <a>link</a></p>
</article>
```

We say that the `<h1>`, `<h2>` and `<p>` elements are children of the `<article>` -- and so, conversely, the `<article>` is their `parent`. The `<a>` is a *child* of the `<p>`, and a  *descendant* of the `<article>`; the `<article>` is an *ancestor* of the `<a>`; the `<h1>`, `<h2>` and  `<p>` are *siblings*, because they have the same parent; `<h1>` and `<h2>` are *adjacent siblings* because there's nothing between them.

We can use these relationships in our selectors. Say we want a rule that says emphasis tags are red, paragraphs are blue, but emphasis tags which are inside paragraphs should be green:

```css
p {
    color: blue;
}

em {
    color: red;
}

p em { /* target em elements which are children of p elements */
    color: green;
}
```

This syntax has caused a great deal of confusion over the years, particularly when very deep nested selectors are involved:

```css
body.news-article header nav menu li#promo a {
    /* TODO: special style fpr  the link inside the promo 
      list item in the menu that's part of the nav inside the 
      header on any page whose body has the news-article class.
}
```

and so, since late 2023, mainstream browsers have supported a new syntax called *CSS nesting*:

```css
em {
	color: red;
}
p {
    color: blue;
    em { /* target em elements which are children of p elements */
        color: green;
    }
}
```

According to [caniuse.com/css-nesting](https://caniuse.com/css-nesting), nesting is fully or partially supported on over 91% of browsers, so despite being a relatively recent addition to the CSS standard, we're going to use nested selectors wherever they make sense throughout the rest of this course.

## Review & Recap

* CSS selectors target the element, or elements, on the page to which our rules should be applied
* The wildcard selector `*` matches **every element on the page, individually**
* Element selectors match HTML elements based on their tag name
* Class selectors match elements based on their `class` attribute
  * One element can have zero, one, or many classes.
  * A page can contain multiple elements with the same class.
* ID selectors match elements based on their `id` attribute
  * Elements cannot have more than one ID
  * A specific ID should never appear more than once on the same page.
* Grouped and nested selectors allow us to target elements based on their *ancestry*, where 
