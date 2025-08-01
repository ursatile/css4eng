#!/usr/bin/env ruby

# Simple test to verify the logic without Jekyll dependencies

# Test HTML content
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

# Extract the core logic from example.rb to test
def extract_element_by_tag(lines, tag_name)
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

  # Extract the content INSIDE the tags (excluding opening and closing lines)
  content_start = start_line + 1  # Line after opening tag
  content_end = end_line - 1      # Line before closing tag

  # If there's no content between tags, return nil
  if content_start > content_end
    return nil
  end

  # Return the range in format for extract_element_by_tag
  "#{content_start}-#{content_end}"
end

def extract_element_by_tag(lines, tag_name)
  range = find_element_by_tag(lines, tag_name)
  return nil unless range

  start_line, end_line = range.split("-").map(&:to_i)
  lines[(start_line - 1)..(end_line - 1)].join
end

def extract_element_by_selector(code, selector)
  lines = code.lines
  # For this test, we only handle simple tag selectors
  extract_element_by_tag(lines, selector)
end

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

  # Return the range in format for extract_element_by_tag
  "#{content_start}-#{content_end}"
end

# Test the extraction
lines = html_content.lines
puts "Original HTML:"
puts html_content
puts "\n" + "=" * 50 + "\n"

# Extract style content
style_content = extract_element_by_selector(html_content, "style")
puts "Style content:"
puts style_content
puts "\n" + "-" * 30 + "\n"

# Extract body content
body_content = extract_element_by_selector(html_content, "body")
puts "Body content:"
puts body_content
puts "\n" + "=" * 50 + "\n"

# Show what the combined output should look like
puts "Combined output (what we want):"
puts style_content
puts
puts body_content
