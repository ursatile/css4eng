---
examples: examples/213-presenting-tabular-data
layout: home
nav_order: 213
target_minutes: 15
title: "Presenting Tabular Data"
parent: Presentation

word_count: 296
---
Tables are one of the web's oldest layout systems, added to HTML 3.2 way back in 1997. For many years, web developers relied extensively on tables because they were just about the only way to break out of the inline/block layout model; it was common to see tables used for everything from the website layout down to individual buttons; the 9-slice scaling technique we discussed in the last section relied on turning every button on the site into a tiny table.

CSS now offers better alternatives to just about every layout scenario which previously relied on tables; we have better ways to control element borders and backgrounds, superior layout models like flexbox and CSS Grid, which we'll meet shortly.

Fundamentally, though, tables are designed to display tabular data --- rows and columns --- and so if that's what you're trying to do, you're much better off sticking with good old HTML tables than trying to reinvent the table using grids, flexboxes, or any number of other ingenious techniques.

A Quick HTML Table Refresher

Fundamentally, an HTML table is a `<table>` element, containing at least one `<tr>` --- table row --- element, which contains at least one `<td>` --- table data --- element.

{% example basic-table.html elements="body" iframe_style="" %}

More comprehensively, a table can include a `<colgroup>` containing `<col>` elements, allowing us to target cells based on their column as well as their row; a header `<thead>`, a body `<tbody>`,  a footer `<tfoot>`, and header cell elements - `<th>`. 

Tables can also include a `<caption>`, describing the contents of the table. Here's a full example of a table containing everything in the current HTML spec:

{% example full-table.html elements="body" iframe_style="" %}

