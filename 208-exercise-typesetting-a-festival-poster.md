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















