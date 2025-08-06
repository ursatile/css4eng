---
examples: examples/208-exercise-typesetting-a-festival-poster
layout: home
nav_order: 208
target_minutes: 15
title: "Exercise: Typesetting a Festival Poster"
word_count: 201
---
In this exercise, we're going to walk through typesetting a poster for a music festival using everything we've learned so far about layout, colour, fonts, and text, and learn a few more things along the way.

Here's the code we're going to start with:

{% example festival.html %}

We've got a `header`, with the name of the festival, the strapline, the date and the venue, then a `<main>` element with a `<section`> for each day of the festival, then inside each section we've got another `<header>` with the date, an `<h1>` with the name of the headline act, `<h2>` and `<h3>` for the second and third acts on that bill, an undordered list of the other acts appearing on that date, and a `<footer>` with details of where we can go to get tickets.

Now, this is a fantastic place to start: it's accessible, responsive, the whole thing is less than 2kb of HTML - and we've got a unique ID on all of the featured bands, which is going to make life a lot easier when we start targeting those elements with complex typographic rules.

Doesn't look like much, though:

{% iframe festival.html %}

So, let's fix it up. 

### Normalize

First, let's add a few normalize styles - these will set everything to use `border-box` sizing, and remove any margins and padding from the `html` and `body` elements.

{% example styles-01-normalized.css %}

### Layout

Next up, we'll create our layout rules:

{% diff styles-02-layout.css diff_baseline="styles-01-normalized.css" %}

{% iframe festival-02-layout.html %}

### Colours and Borders

Then we'll add rules for colours and borders:

{% diff styles-03-colors.css diff_mode="mark" diff_baseline="styles-02-layout.css" %}

 {% iframe festival-03-colors.html %}

### Basic Typography

Let's grab a font from Google Fonts to override the default font across the whole of that page. We're going to use a font called Economica:

* [https://fonts.google.com/specimen/Economica](https://fonts.google.com/specimen/Economica)

Click through to "Get Font", grab the **embed code**, and we're going to use the `@import` syntax - this is CSS' mechanism to import styles and rules from an external URL.

Paste the import rule at the top of our file, and then we're going to add some rules to apply that font, and to override the default formatting for some of our page elements:

{% diff styles-04-fonts.css diff_mode="mark" diff_baseline="styles-03-colors.css" %}

{% iframe festival-04-fonts.html %}

## Artist Logotypes

Next, we're going to use the names of the various featured artists to showcase many of the capabilities of CSS typography.

> OK, listen up. This is a fun way to showcase what CSS typography can do, and see the effects of various font and text properties.
>
> It is a *terrible* way to actually create artwork that incorporates anybody else's logos or logotypes. If you were doing this for a real music festival, you'd get high-quality vector artwork from the artists and use SVG or PNG images to display their logos.
>
> I wouldn't do this on a real project unless the client explicitly told me to recreate their logo using CSS, and provided the colour specs and typefaces, and even then I'd be waiting for the angry email saying it doesn't look right on the boss' 2011 Macbook Pro.

We've done two things in the underlying HTML to make this part of the exercise a little easier; every featured artist element has an associated `id` attribute, and the individual words within each artist's name are wrapped in `<span>` tags.

> CSS has the `::first-letter` and `::first-line` pseudo-elements, but no syntax for targeting specific words within a text element - there's no `::first-word`, `:nth-word` or anything comparable.

{% diff styles-05-logotypes.css diff_baseline="styles-04-fonts.css" %}

{% iframe festival-05-logotypes.html %}

## Review and Recap

In this exercise, we used CSS' layout and typography features to lay out a poster advertising a musical festival.



















