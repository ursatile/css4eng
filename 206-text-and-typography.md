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

## CSS Text Properties

As well as the choice of font, we can change the appearance of text using `font` and `text` properties.

Now, folks, web typography can get unbelievably complicated. A lot of very smart people have spent decades figuring out how to make all of this stuff work, and a fair amount of that time and effort has been spent covering edge cases that the vast majority of us will never encounter: if you want to use CSS to lay out a panel from a graphic novel where one character's arguing in Hebrew and the other one's arguing back in Japanese and the whole thing's rotated by 30% for dramatic effect, you can absolutely do that -- but if we go into every possible option of every typographic property in CSS, we'll be here for hours and you'll learn a whole bunch of things that I'd bet good money you'll never have to use. So I'm going to focus on the ones I think are relevant to the most common scenarios, and I'll leave you some links & pointers where you can go and read up on the rest of it if you really, really want to.

First up, the font properties - `font-family`, `font-size`, `font-stretch`, `font-style`, `font-variant`, `font-weight`, and `line-height`.

Font-family, we've already seen.

Font-size can be one of what I call the T-shirt sizes: `xx-small`, `x-small`, `small`, `medium`, `large`, `x-large`, `xx-large`, `xxx-large`, a relative size keyword `larger` or `smaller`, a length value, or a percentage.

{% example font-size.html iframe_style="height: 20em;" elements="style, body" %}

For units like `em`, which are relative, font size is relative to the parent element, so watch out for compounding font sizes:

{% example relative-font-size.html iframe_style="height: 20em;" elements="style, body" %}









## Using Web Fonts

If you want to use a font which isn't widely available, you can tell the browser to download the font file from the web - either directly from your own site, or from an external provider like Google Fonts. First, find the font you want to use. I've always liked the font PT Sans Narrow, so we're going to use that one as our example. Head over to [www.fontsquirrel.com/fonts/pt-sans](https://www.fontsquirrel.com/fonts/pt-sans), click on "Webfont Kit": 

![](./images/font-squirrel-pt-sans.png)

You'll get the option to download a subset of the font - if you know your website is only ever going to include Latin text, you can download a version of the font file that doesn't include glyphs for Greek, Cyrillic, and other alphabets. You can also choose a format: the Web Open Font Format, WOFF, is really the only one that matters these days. Hit the Download button, and you'll get a ZIP file containing your fonts, along with a load of sample sheets, notes, and the license file.

All we actually need here are the WOFF files, so unzip that file and search through it for the files with .woff extension. You might want to rename them as you go - FontSquirrel's default filenames aren't terribly helpful. If you're using PT Sans, you can grab a ZIP file of just the WOFF files (and the license!) here: [pt-sans.zip]({{page.examples}}/pt-sans.zip)

Next, we need to create the CSS rules which will import those font files and register them with the associated `font-family` name:

{% example pt-sans.html iframe_style="height: 11em;" elements="style, body" %}

Note that the `font-family` designator here is completely arbitrary; it's a good idea to use a `font-family` name that matches the font you're using, but it's not required; you can use any name you like.

{% example ninja-turtle.html iframe_style="height: 11em;" elements="style, body" %}

What's interesting here is that the WOFF file we've provided, `pt-sans.woff`, only defines the regular version of that typeface -- it doesn't include a bold version or an italic version. So where are those variants coming from?

Those are what are called *synthetic fonts*; they're created by the operating system using something called font synthesis. To make a font italic, the OS sort of skews everything sideways a bit; to make it bold, it'll draw every letter with a heavy outline stroke.

That works great, right up to the point where you have a client who is really, *really* particular about fonts and typography --- maybe they've even hired a font foundry to design their company font; they've paid a lot of money for those bold and italic versions and by golly they want to make sure they get used.

First thing to do if you find yourself in this situation is to disable font synthesis:

{% example pt-sans-no-synthesis.html iframe_style="height: 11em;" elements="style" mark_lines="7" %}

Now, we know that if we're seeing bold or italic, it's coming from the font file, not being synthesised by the operating system.

Next, we'll add `@font-face` rules for each variant, specifying the URL to the `.woff` file containing that variant, and using `font-weight` and `font-style` to specify which variant it is:

{% example pt-sans-variants.html iframe_style="height: 11em;" elements="style" mark_lines="17,18,23,24,29,30,31" %}

Notice how the rules all use the same `font-family: 'PT Sans'`, so that we can set a document in PT Sans, and elements with intrinsic styling, like `<h1>` and `<em>` , will use the correct font variant.









# Text & Typography (20m)

## Course Content

- Fonts, weights, styles and variants
- Whitespace, wrap and overflow
- Working with web fonts

## Notes

https://opentype.js.org/font-inspector.html













