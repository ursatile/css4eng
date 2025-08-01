#!/usr/bin/env ruby

# Standalone test copying the fixed methods
class StandaloneTest
  def get_line_range_from_elements(code, elements_spec)
    # Split the elements specification by comma and trim whitespace
    selectors = elements_spec.split(",").map(&:strip)

    # Find all matching elements and their line numbers
    matching_ranges = []

    selectors.each do |selector|
      range = find_element_line_range_by_selector(code, selector)
      matching_ranges << range if range  # Only add non-nil ranges
    end

    return nil if matching_ranges.empty?

    # Find the overall range that encompasses all matching elements
    min_start = matching_ranges.map { |r| r.split("-")[0].to_i }.min
    max_end = matching_ranges.map { |r| r.split("-")[1].to_i }.max

    "#{min_start}-#{max_end}"
  end

  def find_element_line_range_by_selector(code, selector)
    lines = code.lines

    # Parse different selector types
    if selector.include?("#")
      # ID selector like "p#example"
      tag, id = selector.split("#", 2)
      tag = tag.empty? ? "[a-zA-Z][a-zA-Z0-9]*" : Regexp.escape(tag)
      find_element_by_id(lines, tag, id)
    elsif selector.include?(".")
      # Class selector like "div.container"
      tag, class_name = selector.split(".", 2)
      tag = tag.empty? ? "[a-zA-Z][a-zA-Z0-9]*" : Regexp.escape(tag)
      find_element_by_class(lines, tag, class_name)
    else
      # Simple tag selector like "style" or "body"
      find_element_by_tag(lines, selector)
    end
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

    "#{content_start}-#{content_end}"
  end
end

html_content = File.read("final_test.html")
test = StandaloneTest.new

puts "HTML content:"
html_content.lines.each_with_index { |line, i| puts "#{i + 1}: #{line.chomp}" }

puts "\nTesting elements='style':"
result = test.get_line_range_from_elements(html_content, "style")
puts "Result: #{result}"

if result
  lines = html_content.lines
  start_line, end_line = result.split("-").map(&:to_i)
  puts "Content (lines #{start_line}-#{end_line}):"
  puts lines[(start_line - 1)..(end_line - 1)].join
else
  puts "No content found"
end

puts "\nTesting elements='script':"
result = test.get_line_range_from_elements(html_content, "script")
puts "Result: #{result}"

if result
  lines = html_content.lines
  start_line, end_line = result.split("-").map(&:to_i)
  puts "Content (lines #{start_line}-#{end_line}):"
  puts lines[(start_line - 1)..(end_line - 1)].join
else
  puts "No content found"
end
