#!/usr/bin/env ruby

# Test the updated element content extraction
class ContentExtractor
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
        end_line = start_line + relative_index
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

  def find_element_by_id(lines, tag_pattern, id)
    # Look for tag with specific ID
    id_pattern = Regexp.escape(id)
    opening_pattern = /<#{tag_pattern}[^>]*id=["']#{id_pattern}["'][^>]*>/i

    start_line = nil
    lines.each_with_index do |line, index|
      if line.match(opening_pattern)
        start_line = index + 1
        break
      end
    end

    return nil unless start_line

    # Extract the actual tag name from the line for finding the closing tag
    match = lines[start_line - 1].match(/<(#{tag_pattern})[^>]*>/i)
    actual_tag = match ? match[1] : tag_pattern.gsub(/\[.*?\]/, "") # fallback

    # Check if it's a self-closing tag (no content to extract)
    if lines[start_line - 1].match(/<#{Regexp.escape(actual_tag)}[^>]*\/>/i)
      return nil  # Self-closing tags have no content
    end

    # Find the closing tag with proper nesting support
    closing_pattern = /<\/#{Regexp.escape(actual_tag)}>/i
    opening_tag_pattern = /<#{Regexp.escape(actual_tag)}(?:\s[^>]*)?>/i

    end_line = start_line
    nest_count = 1  # We already found one opening tag

    lines[start_line..-1].each_with_index do |line, relative_index|
      # Count opening tags (for nested elements of same type)
      nest_count += line.scan(opening_tag_pattern).length
      # Count closing tags
      closing_matches = line.scan(closing_pattern).length
      nest_count -= closing_matches

      if nest_count == 0
        end_line = start_line + relative_index
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

  def find_element_by_class(lines, tag_pattern, class_name)
    # Look for tag with specific class
    class_pattern = Regexp.escape(class_name)
    # Class can be among other classes, so we need a more flexible pattern
    opening_pattern = /<#{tag_pattern}[^>]*class=["'][^"']*\b#{class_pattern}\b[^"']*["'][^>]*>/i

    start_line = nil
    lines.each_with_index do |line, index|
      if line.match(opening_pattern)
        start_line = index + 1
        break
      end
    end

    return nil unless start_line

    # Extract the actual tag name from the line for finding the closing tag
    match = lines[start_line - 1].match(/<(#{tag_pattern})[^>]*>/i)
    actual_tag = match ? match[1] : tag_pattern.gsub(/\[.*?\]/, "") # fallback

    # Check if it's a self-closing tag (no content to extract)
    if lines[start_line - 1].match(/<#{Regexp.escape(actual_tag)}[^>]*\/>/i)
      return nil  # Self-closing tags have no content
    end

    # Find the closing tag with proper nesting support
    closing_pattern = /<\/#{Regexp.escape(actual_tag)}>/i
    opening_tag_pattern = /<#{Regexp.escape(actual_tag)}(?:\s[^>]*)?>/i

    end_line = start_line
    nest_count = 1  # We already found one opening tag

    lines[start_line..-1].each_with_index do |line, relative_index|
      # Count opening tags (for nested elements of same type)
      nest_count += line.scan(opening_tag_pattern).length
      # Count closing tags
      closing_matches = line.scan(closing_pattern).length
      nest_count -= closing_matches

      if nest_count == 0
        end_line = start_line + relative_index
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

# Test the functionality
html_content = File.read('test_content.html')
extractor = ContentExtractor.new

puts "Original HTML:"
puts "=" * 50
puts html_content
puts "\n"

# Test extracting style content only
puts "Test 1: Extract style content only (no <style> tags)"
puts "=" * 50
range = extractor.get_line_range_from_elements(html_content, "style")
if range
  puts "Line range: #{range}"
  lines = html_content.lines
  start_line, end_line = range.split("-").map(&:to_i)
  content = lines[(start_line - 1)..(end_line - 1)].join
  puts "Content:"
  puts content
else
  puts "No content found"
end
puts "\n"

# Test extracting script content only
puts "Test 2: Extract script content only (no <script> tags)"
puts "=" * 50
range = extractor.get_line_range_from_elements(html_content, "script")
if range
  puts "Line range: #{range}"
  lines = html_content.lines
  start_line, end_line = range.split("-").map(&:to_i)
  puts "Start line: #{start_line}, End line: #{end_line}"
  puts "Total lines in file: #{lines.length}"
  content = lines[(start_line - 1)..(end_line - 1)].join
  puts "Content:"
  puts content
  puts "--- End of content ---"
else
  puts "No content found"
end
