---
layout: home
nav_order: 104
target_minutes: 18
title: "Introducing Web Accessibility"
word_count: 2462
---

Something else to bear in mind as we get further into all this: not all browsers are the same. For a long while in the early days of the web, the two main browsers, Netscape and Internet Explorer, had a lot of fundamental incompatibilities, so for anything too complex you'd end up having to maintain two different versions of your JavaScript code. We called this the "browser wars" - and fortunately the browser wars are ancient history now; all of the mainstream web browsers out there these days have excellent support for modern web standards.

What we have seen, though, is a proliferation of devices. Somebody could be viewing your web page on a laptop, a mobile phone, a smartwatch, a desktop computer with a 52" ultrawide display - and so as we start to think about styling and layout, we've got to consider what'll happen to our pages across a whole range of screen layouts and sizes.

We've also got to remember that the user controls their own browser. If they want bigger fonts, easy - they can go into Settings, Appearance, Font size, and whack that up to Large, or Extra Large. If they're fed up of Times New Roman, they can go into Customise Fonts and set their standard font to Arial, or Calibri, or even Comic Sans. It's enlightening to browse your usual favourite websites with the font size cranked up. Some sites - like the BBC News site - handle this extremely well, because the whole layout is based on the base font size, so everything else expands to compensate. Some sites - like Reddit - override the defaults with their own hard-coded font size, so changing the browser settings doesn't actually do anything. And some sites - like Gmail - will respect the font size, but don't adjust their layout to compensate so things end up looking really weird. And then there's Page Zoom, which just lets you make the whole page bigger and smaller.

What actually ends up on your user's screen is going to be a compromise between your site's design, and the end user's settings and preferences - and that's important. Accessibility is a big deal, and a key part of making your online content accessible is giving your end users control over the things they might need to change. If text is too small, they should be able to make it larger. If you're presenting important information via diagrams or images, provide an alternative for people who can't see those images.

One thing I want to mention while we're here: for as long as I've been developing websites, people have been talking about using tags like `strong` and `em` - instead of just making text bold or italic - because, in theory, something like screen reader software could emphasise those elements. Sounds like a good idea, right? And nobody's going to argue *against* that... but, unfortunately, it isn't actually true. Let's add a couple more paragraphs to our example page here - let's have one that's just a regular paragraph, our existing one that uses the `em` tag, and a third one that uses a `strong` tag. Now I'm going to open up the NVDA screen reader software, and listen to how it reads out that content:

That's not a case *against* semantic markup - in fact, using well-structured markup is an excellent starting point when it comes to making web content accessible. But the example of `em` tags and screen readers is so ubiquitous that I thought it was worth pointing out that it's Not Actually A Thing.

## Review & Recap

In this section, we've discussed why CSS is so unpopular with developers:

* CSS uses a declarative programming model, not a procedural one: you don't provide instructions, you describe results.
* CSS is closely associated with visual design, and so books and training material often treat CSS as part of a design toolkit rather than an engineering capability
* CSS is hard to test; bugs and regressions will often go unnoticed until somebody complains that "the website is broken"
* There's a lot of very bad CSS code in the wild; many of us have ended up having to work with it at some point in our career, and that contributes a lot of negativity to developers' perception of CSS as a language.













