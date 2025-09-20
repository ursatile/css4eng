# Example Usage

The `elements` parameter now works with the example plugin. Here are some usage examples:

## Extract a single element:
```liquid
{% example index.html elements="style" %}
```

## Extract multiple elements:
```liquid
{% example index.html elements="style,script" %}
```

## Extract element by ID:
```liquid
{% example index.html elements="p#intro" %}
```

## Extract element by class:
```liquid
{% example index.html elements="div.container" %}
```

## Extract mixed selectors:
```liquid
{% example index.html elements="head,body" %}
{% example index.html elements="style,p#intro,div.container" %}
```

## How it works:

1. The plugin reads the HTML file
2. **NEW**: If `elements` parameter is provided and the file is HTML, it extracts only the matching elements
3. The code is then syntax highlighted
4. Other filters (like `only_lines`, `mark_lines`) are applied after highlighting
5. The result is displayed

## Supported selectors:

- **Tag selectors**: `style`, `body`, `head`, `script`, `div`, `p`, etc.
- **ID selectors**: `p#intro`, `div#main`, `#anyid` (any tag with that ID)
- **Class selectors**: `p.highlight`, `div.container`, `.anyclass` (any tag with that class)
- **Multiple selectors**: Comma-separated list like `style,script,p#intro`

## Notes:

- Only works with HTML files (based on file extension)
- Handles nested elements correctly
- Preserves original formatting and indentation
- Self-closing tags are supported
- If no elements match, the original code is used
