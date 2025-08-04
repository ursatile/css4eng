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

## Using Web Fonts

If you want to use a font which isn't widely available, you can tell the browser to download the font file from the web - either directly from your own site, or from an external provider like Google Fonts. First, find the font you want to use. I've always liked the font PT Sans Narrow, so we're going to use that one as our example. Head over to [www.fontsquirrel.com/fonts/pt-sans](https://www.fontsquirrel.com/fonts/pt-sans), click on "Webfont Kit": 

![](./images/font-squirrel-pt-sans.png)

You'll get the option to download a subset of the font - if you know your website is only ever going to include Latin text, you can download a version of the font file that doesn't include glyphs for Greek, Cyrillic, and other alphabets. You can also choose a format: the Web Open Font Format, WOFF, is really the only one that matters these days. Hit the Download button, and you'll get a ZIP file containing your fonts, along with a load of sample sheets, notes, and the license file.

All we actually need here are the WOFF files, so unzip that file and search through it for the files with .woff extension. You might want to rename them as you go - FontSquirrel's default filenames aren't terribly helpful. If you're using PT Sans, you can grab a ZIP file of just the WOFF files (and the license!) here: [pt-sans.zip]({{page.examples}}/pt-sans.zip)

Next, we need to create the CSS rules which will import those font files and register them with the associated `font-family` name:

{% example pt-sans.html iframe_style="height: 11em;" elements="style, body" %}

What's interesting here is that the WOFF file we've provided, `pt-sans.woff`, only defines the regular version of that typeface -- it doesn't include a bold version or an italic version. So where are those variants coming from?

Those are what are called *synthetic fonts*; they're created by the operating system using something called font synthesis. To make a font italic, the OS sort of skews everything sideways a bit; to make it bold, it'll draw every letter with a heavy outline stroke.

That works great, right up to the point where you have a client who is really, *really* particular about fonts and typography --- maybe they've even hired a font foundry to design their company font; they've paid a lot of money for those bold and italic versions and by golly they want to make sure they get used.

First thing to do if you find yourself in this situation is to turn off font synthesis:

{% example pt-sans-no-synthesis.html iframe_style="height: 11em;" elements="style" mark_lines="7" %}







 When it comes to variants like bold and italic, there are three different things that can happen:

1. You treat them as completely different font families, so that `PT Sans` and `PT Sans Bold` are entirely separate.
2. You import two separate files into the same `font-family`, and specify that one of them is regular weight and the other is bold.
3. You just import the regular variant, and let the browser - or rather, the operating system - create bold and italic versions of it as required. This is known as *font synthesis*.





































# Text & Typography (20m)

## Course Content

- Fonts, weights, styles and variants
- Whitespace, wrap and overflow
- Working with web fonts

## Notes

https://opentype.js.org/font-inspector.html













