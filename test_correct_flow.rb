#!/usr/bin/env ruby

# Test the corrected flow: identify lines -> highlight entire input -> extract lines

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

# Simulate step 1: Find line ranges for elements
def find_element_by_tag(lines, tag_name)
  tag_pattern = Regexp.escape(tag_name)
  opening_pattern = /<#{tag_pattern}(?:\s[^>]*)?>/i
  closing_pattern = /<\/#{tag_pattern}>/i
  self_closing_pattern = /<#{tag_pattern}[^>]*\/>/i

  start_line = nil
  lines.each_with_index do |line, index|
    if line.match(opening_pattern) || line.match(self_closing_pattern)
      start_line = index + 1  # Convert to 1-based indexing
      break
    end
  end

  return nil unless start_line

  # Check if it's a self-closing tag (no content to extract)
  if lines[start_line - 1].match(self_closing_pattern)
    return nil  # Self-closing tags have no content
  end

  # Find the closing tag - start searching from the line after the opening tag
  end_line = start_line
  nest_count = 1  # We already found one opening tag

  lines[start_line..-1].each_with_index do |line, relative_index|
    # Count opening tags (for nested elements of same type)
    nest_count += line.scan(opening_pattern).length
    # Count closing tags
    closing_matches = line.scan(closing_pattern).length
    nest_count -= closing_matches

    if nest_count == 0
      end_line = start_line + relative_index + 1  # +1 to convert back to 1-based indexing
      break
    end
  end

  # Return the range INSIDE the tags (excluding opening and closing lines)
  content_start = start_line + 1  # Line after opening tag
  content_end = end_line - 1      # Line before closing tag

  # If there's no content between tags, return nil
  if content_start > content_end
    return nil
  end

  "#{content_start}-#{content_end}"
end

lines = html_content.lines
puts "Original HTML (with line numbers):"
lines.each_with_index do |line, i|
  puts sprintf("%2d: %s", i + 1, line)
end

puts "\n" + "=" * 50 + "\n"

# Step 1: Find line ranges for style and body
style_range = find_element_by_tag(lines, "style")
body_range = find_element_by_tag(lines, "body")

puts "Step 1 - Line ranges identified:"
puts "Style range: #{style_range}"
puts "Body range: #{body_range}"
puts

# Step 2: This would be where Rouge highlights the ENTIRE input
puts "Step 2 - Apply syntax highlighting to entire input (simulated)"

# Step 3: Extract the specific line ranges
puts "Step 3 - Extract lines from highlighted output:"
if style_range && style_range =~ /^(\d+)-(\d+)$/
  start_line, end_line = $1.to_i, $2.to_i
  puts "\nStyle content (lines #{start_line}-#{end_line}):"
  lines[(start_line - 1)..(end_line - 1)].each { |line| puts "  #{line}" }
end

if body_range && body_range =~ /^(\d+)-(\d+)$/
  start_line, end_line = $1.to_i, $2.to_i
  puts "\nBody content (lines #{start_line}-#{end_line}):"
  lines[(start_line - 1)..(end_line - 1)].each { |line| puts "  #{line}" }
end
