---
examples: examples/204-css-resets-and-normalizers
layout: home
nav_order: 204
target_minutes: 5
title: "CSS Resets & Normalizers"
word_count: 588
---
As we saw in the last few sections, every browser includes a collection of default styles it'll apply to elements of unstyled HTML. Headings are big and bold, unordered lists get bullet points, links are draw in blue and underlined.

Historically, these default styles would vary dramatically from one browser to the next, and so a lot of developers got into the habit of using something called a CSS reset. The most enduring example of this is a reset CSS created by Eric Meyer, way back in 2011:

* [https://meyerweb.com/eric/tools/css/reset/](https://meyerweb.com/eric/tools/css/reset/)

{% example reset-eric-meyer.css %}

and our kitchen sink page with Eric's CSS reset looks like this:

{% iframe kitchen-sink-eric-meyer-reset.html %}

There are two more recent CSS resets worth knowing about. One was created by Andy Bell from set.studio in 2023:

* [https://piccalil.li/blog/a-more-modern-css-reset/](https://piccalil.li/blog/a-more-modern-css-reset/)

{% example reset-andy-bell.css %}

The kitchen sink page with Andy Bell's reset applied looks like this:

{% iframe kitchen-sink-andy-bell-reset.html %}

More recently, Josh W. Comeau created a [modern CSS reset](https://www.joshwcomeau.com/css/custom-css-reset/), incorporating a lot of the ideas from Eric and Andy's versions, and updated to reflect modern usage and incorporate some newer CSS features like `text-wrap: pretty` which we'll meet in the next few sections.

* [https://www.joshwcomeau.com/css/custom-css-reset/](https://www.joshwcomeau.com/css/custom-css-reset/)

 {% example reset-josh-w-comeau.css %}

The kitchen sink page with Josh W Comeau's reset applied looks like this:

{% iframe kitchen-sink-josh-w-comeau-reset.html %}

## Reset vs Normalize

You'll notice in the examples above that Eric Meyer's reset removes just about *every* style; headings, labels, inputs, they all end up looking exactly the same. That's the intention: to remove every trace of default styling so you can then build up your own library of styles to suit the design of your site.

Although Josh and Andy describe their versions as CSS resets, what they're really doing is *normalising*; they're preserving the default styles but overriding anything that's inconsistent or idiosyncratic, so when you use them as a basis for your own styles, you don't need to build everything from scratch, but you are less likely to encounter surprises and weird edge cases.

There are a few other projects out there which specifically describe themselves as CSS normalizers; the most notable one being Sindre Sorhus' **modern-normalize**:

* [https://github.com/sindresorhus/modern-normalize](https://github.com/sindresorhus/modern-normalize)

{% example modern-normalize.css %}

{% iframe kitchen-sink-modern-normalize.html %}

If you want to see all four of them side-by-side:

{% iframe comparing-css-resets.html %}

## Do I need a CSS normalizer?

Short answer: no, you don't *need* one. They don't do anything you can't accomplish yourself -- and if you're taking over maintenance of an existing site which doesn't use one, then adding a normalizer or a CSS reset to an existing site is a very risky proposition indeed; it could break all kinds of things that you won't find out about until angry users file support tickets asking why the site doesn't work.

That said, if you're building a greenfield web app, a library like **modern-normalize** does provide a solid foundation for styling your own sites and applications.

The drawback of using any kind of reset library is that it means before you even start building your own styles, there's a bunch of rules in there which are going to affect the way the browser renders elements on your page, so when you're troubleshooting or debugging anything, you've got to remember to consider both the browser's underlying behaviour and any normalization or reset rules which might be affecting it.

We're not going to use an off-the-shelf reset or a normalizer in the rest of this course, but I will be using a small set of normalizing styles in many of the exercises, and I'll explain as we go along which styles are being normalized and why it's relevant to that particular scenario.
