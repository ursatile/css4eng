---
title: "Exercise: Typesetting a Festival Poster"
layout: home
nav_order: 208
word_count: 201
target_minutes: 15
examples: examples/208-exercise-typesetting-a-festival-poster
av_order: 208
av_order: 208
---
In this exercise, we're going to walk through typesetting a poster for a music festival using everything we've learned so far about layout, colour, fonts, and text, and learn a few more things along the way.

Here's the code we're going to start with:

{% example festival.html %}

We've got a `header`, with the name of the festival, the strapline, the date and the venue, then a `<main>` element with a `<section`> for each day of the festival, then inside each section we've got another `<header>` with the date, an `<h1>` with the name of the headline act, `<h2>` and `<h3>` for the second and third acts on that bill, an undordered list of the other acts appearing on that date, and a `<footer>` with details of where we can go to get tickets.

Now, this is a fantastic place to start: it's accessible, responsive, the whole thing is less than 2kb of HTML - and we've got a unique ID on all of the featured bands, which is going to make life a lot easier when we start targeting those elements with complex typographic rules.

Doesn't look like much, though:

{% iframe festival.html %}

So, let's fix it up.

First, we'll give it some layout.

