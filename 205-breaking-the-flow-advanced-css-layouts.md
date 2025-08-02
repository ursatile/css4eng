---
title: "Breaking the Flow: Advanced CSS Layouts"
layout: home
nav_order: 205
word_count: 30
target_minutes: 20
examples: examples/205-breaking-the-flow-advanced-css-layouts
---
As we saw a little while ago, most web pages have an intrinsic document flow, based around the idea of block and inline elements. We've also learned about the CSS box model --- content, padding, border, and margins --- and about how to specify sizes and layout using pixels, relative units like ems and rems, and the viewport-based units vh and vw.

In this section, we're going to learn some techniques we can use to break out of the document flow model and take much greater control of our page layouts.

Before we get into that, though, let's have a quick refresh about viewports.

## Viewports and Scrolling

When we use the word *screen*, we mean the entire physical display. A screen has a size, and a resolution. Size is physical: my laptop screen is 30 by 20 centimetres; my phone screen is 6 by 10 centimetres; the projector screen in a conference auditorium is 20 metres wide. The resolution tells us how many pixels that screen has - and with high-DPI displays, physical pixels aren't the same as logical pixels. My iPhone has 750 by 1334 physical pixels, but if you ask JavaScript to print the screen width and height, it says it's 375 x 667 - which is exactly half the physical resolution, because on my phone each logical pixel is actually a 2x2 block of physical pixels.

Next, there's the window. On a desktop or laptop, this is the browser window, which you can move and resize - and that window might have a title bar, address bar, toolbar, bookmarks, tabs, developer tools, status bar... and, somewhere in the middle, the *viewport*. 

The viewport is the bit which actually shows you the web page - or part of it, because the page is often bigger than the viewport. In computer graphics, you'll sometimes hear this referred to as the canvas, but on the web, if we use the word *canvas* we usually mean an HTML `<canvas>` element, so the thing that scrolls around behind the viewport is usually just called the *document*.

One final thing to bear in mind is what happens when the user zooms the page --- because there's two different kinds of zoom to think about. Desktop browsers have a feature called page zoom: that's the one you get by pressing <kbd>Ctrl</kbd>+<kbd>+</kbd>, or holding <kbd>Ctrl</kbd> and rolling the mouse wheel. Page zoom makes everything on the page bigger --- text, images, videos --- but it usually doesn't affect the viewport; the browser recalculates the page layout.

On mobile devices like smartphones, there's a feature called *pinch zoom*, which enlarges the whole page but doesn't affect the layout. Instead, you end up with two viewports - there's the *visual viewport*, which is the bit that's still on the screen, and the *layout viewport*, which is the one the browser uses to lay out the page.

Sometimes, they're all the same. If you view a really short page on your mobile phone screen --- short enough that it doesn't scroll --- then the screen, the window, the viewport and the document are all the same size, and things are very easy indeed. But as we learn about more complex layouts, it's important to think about whether we're arranging elements relative to the document or to the viewport. 

## Using CSS Position

In most of the examples we've looked at so far, the browser decides where to place each element on the page. Inline elements go next to the previous element, block elements go underneath the previous element; if the page ends up too wide, elements will wrap onto the next line, and if the page ends up too tall, we get a vertical scrollbar.

This behaviour is known as *static* positioning, and it's the default: every element in HTML has `position: static` unless we change it. Static layout works really well for articles, documents, blog posts, that kind of thing, but as we start incorporating more sophisticated navigation and interaction into our websites, we're going to need more options when it comes to layout.

Let's start with *relative* positioning. This lets us move an element relative to its original position, hence the name. If we say `top: 10px`, it'll move it down the page by ten pixels - remember, coordinates start at the top left and increase downwards and to the right. 

{% example position-relative.html elements="style,body" iframe_style="height: 12em;" %}

You see that middle paragraph? The one that's going places? It's moved down and to the right --- but also, because the paragraph *width* is still based on the width of the *viewport*, moving it to the right means we end up with a horizontal scrollbar.

Relative positioning is useful if you've got an icon or a button that's not *quite* in the right place and you just need to nudge it by a few pixels, but it's mostly used because it has an incredibly useful side-effect we'll learn about in a moment.

First, though, let's meet *absolute positioning*. Using `position: absolute`, we can specify exactly where an element should be placed within its parent element:

{% example position-absolute.html elements="style,body" iframe_style="height: 14em;" %}

Unlike relative positioned elements, absolute positioned elements don't take up any space in the document flow. The browser doesn't leave a gap where they used to be; it yanks them out of the flow, draws everything else, and then slaps them over the top --- which means if you're not careful, you can easily end up with text that's unreadable because it's hidden behind another element.

In the example above, the absolute-positioned elements are all positioned relative to the document's body... but if you create a parent element with `position: relative`, any absolute-positioned child elements will be positioned relative to that parent.

{% example relative-absolute-position.html iframe_style="height: 16em;" %}

And yes, the terminology here can get very confusing when we talk about absolute-positioned elements being positioned relative to relative-positioned elements.

 







# Breaking the Flow: Advanced CSS Layouts (20m)

## Course Content

- Towards a responsive layout: `max-width`, `min()`, `max()`, `clamp()`
- position: `fixed`, `absolute`, `relative`, `sticky`
- Viewports and scrolling
- Using `height` and `overflow`

## Notes













