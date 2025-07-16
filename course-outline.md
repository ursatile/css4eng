## Part 1: Introduction and Background (45m)

### Course overview (5m)

- Welcome: who am I?
- Overview: what can you expect to learn?  
- Prerequisites: what should you already know?
### Fundamentals and Background (20m)

* Why do so many developers struggle with CSS?
	* Approaches and methodologies
* HTML and semantic markup
* The structure of CSS: syntax, selectors, inheritance, cascading, nested CSS
* Inline vs internal vs external
* How browsers read CSS
* Web Content Accessibility Guidelines (WCAG)
### Tools and Workflows (20m)

* Live previews, hot reload, BrowserLink
* Debugging CSS with browser dev tools
* Managing CSS - using a "kitchen sink" page
* Using CSS rules for debugging: background-color and outline
* Checking CSS support at caniuse.com
## Part 2: Pages and Forms (2 hr 40m)

This part explores the use of CSS in applications that are primarily page-based, where user interaction is limited to clicking links and filling out forms.
### Boxes & Borders (20m)

* The grain of the web: left to right, top to bottom
* Understanding inline and block elements
* The box model: margins, padding, border, outline
* Normalizers and CSS resets - what do they do (and should you use one?)
* Borders & outlines
* CSS units: `0`, `px`, `em`, `rem`, `%`, `vh/vw`
* Basic layout using floats and width
* Exercise: laying out a news site article
### Selectors, Pseudo-Classes and Pseudo-Elements (20m)

* Basic selectors:`*`, element, className, id
* State selectors: `:link`, `:visited`, `:active`, `:hover`, `:focus`
* Attribute selectors: `=-=`, `~=`, `|=`, `^=`, `$=`, `*=`
* Structural selectors: `:first-child`, `:last-child`, `:only-child`, `:nth-child(n)`, `:nth-last-child(n)`, `:first-of-type`, `:last-of-type`, `:only-of-type`, `:nth-of-type(n)`, `:nth-last-of-type(n)`, `:empty`
* Combinators: `A B`, `A > B`, `A + B`, `A ~ B`, `A || B` *(draft)*
* Match selectors: `:not()`, `:is()`, `:where()`, `:has()`
* Pseudo-elements: `::first-line`, `::first-letter`, `::before`, `::after`, `::placeholder`, `::marker`, `::selection`
* using `attr()` in `content`
* Exercise: Building a CSS mosaic
### Breaking the Flow: Advanced CSS Layouts (20m)

* Towards a responsive layout: `max-width`, `min()`, `max()`, `clamp()`
* position: `fixed`, `absolute`, `relative`, `sticky`
* Viewports and scrolling
* Using `height` and `overflow`
### Text & Typography (20m)

* Fonts, weights, styles and variants
* Whitespace, wrap and overflow
* Working with web fonts
### Lists and Counters (20m)

* Understanding CSS counters
* Modifying counters with `counter-reset` and `counter-increment`
* Using counters in `content`
### Colors and Composition (20m)

* The CSS Color Model:  named colors, hex codes, `rgba()`, `hls`
* Beyond boxes: border-radius and backgrounds: `color`, `image`, `origin`, `size`, `position`
* Understanding stacking contexts
* Compositing multiple backgrounds
* Using css `filter`: `blur()`, `brightness()`, `contrast()`, `drop-shadow()`, `grayscale()`, `hue-rotate()`, `invert()`, `opacity()`, `saturate()`, `sepia()`
### Introducing CSS Flexbox (20m)

* flex vs inline-flex
* Building an interactive CSS flexbox visualiser
	* covers flex-direction, flex-wrap, justify-content, align-items, align-content, gaps, flex grow/shrink/basis, alignment and order
* Exercise: building a flexbox image gallery
### Column-Based Layouts (20m)

* Understanding column-based layouts
* Building a 960 grid system (and why it's not the same thing as a CSS grid!)
*  Responsive design with @media queries
* Exercise: responsive registration form
### Presenting Tabular data (20m)

* Styling HTML tables
* Working with tabular layouts: presenting rows & columns, striping, highlighting, hovering
* CSS table tricks: rotating column headers
* Exercise: building a data grid
## Part 3: Applications and Interaction Design (2 hr)

In part 3, we move onto looking at the CSS features and capabilities aimed at developing interactive web applications - interaction design, animation, grid layouts for building rich user experiences, variables, and advanced CSS visual effects.
### Atoms, Molecules and Organisms (20m)

* Beyond Basic Buttons: FontAwesome, CSS shapes, inline SVGs, PNG images, emoji
* Exercise: building a CSS control bar for a media player
### Movement and Motion (20m)

* Animations and CSS transitions
* Triggering interactions: hover, click, scroll, JS events
* Parallax scrolling
* Exercise: animated airline departure board grid
### Using CSS Grid (30m)

* Display: `grid` and `inline-grid`
* Grid-template columns, rows, areas
* grid-colum (+ start and end)
* grid-row (+ start and end)
* grid-area
* place - items, content, self
* justify and align
* auto grids - flow, columns and rows
### Working with CSS Variables (20m)

* Introduction to CSS variables
* Variables and fallbacks
* Using variables in calculations
* Environment variables with `env()`
### Advanced Visual Effects (30m)

* Clip-path
* Shapes and clipping functions: `circle()`, `ellipse()`, `insert()`, `polygon()`, `path()`
* CSS transforms: `translate()`, `scale()`, `rotate()`, `skew()`, `matrix()`, `matrix3d`
* CSS color calculations and color spaces
### Exercise: Building a Web Media Player

An in-depth exercise combining material from each part to build an interactive web-based music player, including playlists, controls, scrolling, interaction design and more.
## Part 4: Beyond CSS (2 hr)
### Scoping CSS (20m)

* Web components and the shadow DOM
* Working with scoped CSS
### Testing and Deployment (20m)

* Minifying and bundling CSS
* Visual regression testing with BackstopJS and Percy.io
* Performance testing with Lighthouse
* Testing websites for accessibility
### CSS Frameworks (30m)

* Bootstrap
* Tailwind
* Materialize
* Foundation
* Bulma
* Skeleton
### Processing CSS (30m)

* SASS
* LESS
* Stylus
* CSS-in-JS
* PostCSS 
## Conclusion (20m)

* Review and recap
* The future of CSS
* FAQ (20m)
* Thank you
 