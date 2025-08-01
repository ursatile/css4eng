#!/usr/bin/env ruby

# Test specifically for the elements="style,body" bug fix

# Load the extraction code
require_relative "test_elements_simple.rb"

puts "Testing the specific bug fix for elements=\"style,body\":"
puts "=" * 60

# Test HTML with style and body
html_content = <<~HTML
  <!DOCTYPE html>
<html lang="en">
<head>
    <title>Test</title>
    <style>
        body {
            background-color: red;
            font-family: Arial;
        }
        h1 {
            color: blue;
        }
    </style>
</head>
<body>
    <h1>Hello World</h1>
    <p>This is a test paragraph.</p>
    <div class="container">
        <span>Some content here</span>
    </div>
</body>
</html>
HTML

extractor = ElementExtractor.new

# Test individual elements first
puts "\n1. Testing elements=\"style\" (individual):"
result = extractor.filter_by_elements(html_content, "style")
puts result

puts "\n2. Testing elements=\"body\" (individual):"
result = extractor.filter_by_elements(html_content, "body")
puts result

puts "\n3. Testing elements=\"style,body\" (combined - this should show both separately):"
result = extractor.filter_by_elements(html_content, "style,body")
puts result

puts "\n" + "=" * 60
puts "Expected behavior: Style content, then blank line, then body content"
puts "NOT: Everything from <style> to </body> including <head> etc."
