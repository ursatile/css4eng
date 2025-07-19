---
title: "How CSS Works"
layout: home
nav_order: 10103
examples: "examples/01-03-how-css-works"
---

## Properties and Values

CSS, fundamentally, allows us to do three things:

1. Select an element, or elements, on a web page.
2. Choose a property which is relevant to that element.
3. Assign that property to a value, which controls how the browser will display it.

The simplest way to do this is what's called `inline CSS`. We're going to find an element on our page - say, that heading 1 - and we're going to add a `style` attribute containing a property - `color` - and a value - `green`. You can probably figure out what that means, right? Yep, draw that heading using the colour green.

> I'm British. I say *colour*, with a *u*. 
>
> Despite being invented in Switzerland by [Håkon Wium Lie](https://en.wikipedia.org/wiki/Håkon_Wium_Lie), who is Norwegian, and [Bert Bos](https://en.wikipedia.org/wiki/Bert_Bos), who is Dutch, and being heavily influenced by HTML created by Tim Berners-Lee, who is also British. CSS uses the American spelling `color`, without a `u`
>
> 

The keyword `color` is one of literally hundreds of properties defined by the CSS language. There are properties for colors, fonts, size, layout, position, animation - and we're going to meet just about all of them in this course. The value `green` is one of the 148 named colours defined in the current CSS specification -- and as we'll see later, named colours is just one of several different colour systems supported by CSS.

And that rule gets applied to the H1 element because we've declared it inline, using the `style` attribute. So far, so good. But what if we wanted all our paragraphs to be purple?

Sure, we could add a `style` attribute to every paragraph... copy, paste, paste... but that's not ideal. There's a principle in software engineering called DRY - Don't Repeat Yourself; the idea that every decision about your application should be reflected in your code in exactly one place. We've decided to make our paragraphs purple - that's one decision - and at the moment, it's reflected in our code in three different places, which is bad.

## Introducing Selectors

Let's meet CSS selectors. Instead of putting our styles inline, we're going to add a `style` element to the `head` of our page. This lets us define rules that apply to everything on the page, but to do that, we need to add something called a `selector`, which tells the browser which element, or elements, each rule applies to.

Let's add a selector `p`, which matches any paragraph element, then open braces, put in our rule - `color: purple` - and close braces. That's a CSS rule: paragraphs on this page should be purple.

You'll notice that the `em` and the `strong` elements there have also changed colour, but the text on the button hasn't. This is because of the C in CSS, which stands for `cascading`. What's actually happening here is that we've defined a rule saying "stuff in paragraphs should be purple", but the browser has a default rule that says "buttons should have black text on a grey background", and in this situation, the browser rule about buttons takes precedence over our new rule about paragraphs. We'll talk a lot more about this when we get to the part about `specificity`, because understanding how the browser decides which rules to apply, and which rules to ignore, is a vitally important part of understanding how CSS actually works.

OK, so: inline styles? Great if you only need to use something once. Putting a style block in the header? Great if you only need to use styles on one page. But it turns out most web applications have more than one page - even the ones that call themselves single-page apps - and so what most sites do is to put all the CSS in a separate file and then import that using an HTML `link` tag

Create a new file, `styles.css`, and move the contents of that `style` block into the new file. 

```css
{% include_relative {{ page.examples }}/styles.css %}
```

Then remove the empty `style` element, and replace it with a `<link>` element:

{% highlight html mark_lines="6" %}
{% include_relative {{ page.examples }}/index.html %}
{% endhighlight %}

The `<link>` element has two attributes:

* `rel` is short for *relationship* - in this case, `"stylesheet"` indicates that the linked file contains CSS rules to apply to the page
* `href` is the URL of the file to load.

> Another historical quirk: you'll often see `link` elements include an extra attribute: `type="text/css"` - a relic of the days when servers would serve CSS files with the wrong MIME type and browsers weren't smart enough to ignore it.

We've now got a page which will load CSS rules from a separate file - and that's a big deal, because we can have many pages which load their CSS rules from that same file, and so our CSS is now reusable. We're not writing stylesheet rules for each page, we're building a stylesheet that applies to our entire website.

## CSS Comments

Like most programming languages, CSS lets us put comments in our code - either to explain what's going on, or to temporarily disable a particular rule or selector.

CSS only has a single style of comment - a comment starts with `/*` and ends with `*/`, and comments can't be nested.

```css
/* An example of a CSS comment */
p {
    color: green;
    /* font-size: 200%; */
}
```

Remember, the point of comments in CSS - and in any language - isn't to tell us what the code does. We can figure that out by reading it. Here's an example of a bad comment:

```css
/* Make all paragraphs large */
p {
    font-size: large;
}
```

...we can tell that's going to make paragraphs large, because we can read the CSS rule! A good comment tells the next person to read the code something useful which they can't infer just from reading it:

```css
h1 {
    /* Using actual black here causes weirdness with dark mode, so we use
    a very, very dark grey color instead. */
    color: #010101;
}
```

## Review & Recap

In this section, we learned about the core structure of CSS, how the CSS language actually works, and how browsers read CSS rules when they're rendering a web page.

* CSS is built around three basic units of syntax:
  * **selectors** control which elements are affected by a rule
  * **properties** control which aspect of those elements we're modifying
  * **values** are what actually changes it.
* CSS rules can be:
  * **Inline**, inside a `style` attribute that's part of the HTML tag
  * **Internal**, contained in a `<style>` element in the `<head>` of a document
  * **External**, loaded from a separate file using a `<link>` element.
