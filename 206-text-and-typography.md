---
title: "Text & Typography"
layout: home
nav_order: 206
word_count: 75
target_minutes: 15
examples: examples/206-text-and-typography
---
Every example we've looked at so far has used the browser's default font, and in my case, that's Times New Roman. And I don't know about you folks, but I'm getting a little bored of Times New Roman... nothing wrong with it, it's just a bit... nondescript, you know?

Let's mix things up a bit.

Using CSS, we can control just about every detail of how text is rendered onto the screen, starting with the font. By specifying a `font-family`, we tell the browser "hey, render this element using this font" - well, kinda. The problem is, we can't guarantee that a particular font will be available on every machine, so instead, we specify something called a font stack:

```css
p {
    font-family: "Franklin Gothic", Arial, Helvetica, sans-serif;
}
```

The browser's going to start at the beginning: "do I have Franklin Gothic?" If that font's available, use it, otherwise check for Arial; if Arial's not available, use Helvetica, and if that's not available either, use any generic sans-serif font.

The keyword `sans-serif` there isn't a font, it's a generic font family name. CSS defines five of these --- `serif`, `sans-serif`, `monospace`, `cursive`, and `fantasy` --- but it's up to the browser to decide what typeface to use for each generic family.

{% example generic-font-family.html iframe_style="height: 23em;" elements="section" %}

This example shows a range of CSS font stacks, along with a sample image showing what they look like on my Windows 11 workstation.

























# Text & Typography (20m)

## Course Content

- Fonts, weights, styles and variants
- Whitespace, wrap and overflow
- Working with web fonts

## Notes

https://opentype.js.org/font-inspector.html













