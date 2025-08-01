#!/usr/bin/env ruby

# Simple test to verify the element filtering works correctly
class MockExampleTag
  def initialize(elements_spec)
    @highlight_options = { elements: elements_spec }
    @lang = "html"
  end

  def filter_by_elements(code, elements_spec)
    # Split the elements specification by comma and trim whitespace
    selectors = elements_spec.split(",").map(&:strip)

    # Find all matching elements and extract their content
    matched_content = []

    selectors.each do |selector|
      element_content = extract_element_by_selector(code, selector)
      matched_content << element_content if element_content
    end

    return nil if matched_content.empty?

    # Join all matched content with newlines
    matched_content.join("\n")
  end

  def extract_element_by_selector(code, selector)
    lines = code.lines

    # Parse different selector types
    if selector.include?("#")
      # ID selector like "p#example"
      tag, id = selector.split("#", 2)
      tag = tag.empty? ? "[a-zA-Z][a-zA-Z0-9]*" : Regexp.escape(tag)
      extract_element_by_id(lines, tag, id)
    elsif selector.include?(".")
      # Class selector like "div.container"
      tag, class_name = selector.split(".", 2)
      tag = tag.empty? ? "[a-zA-Z][a-zA-Z0-9]*" : Regexp.escape(tag)
      extract_element_by_class(lines, tag, class_name)
    else
      # Simple tag selector like "style" or "body"
      extract_element_by_tag(lines, selector)
    end
  end

  def extract_element_by_tag(lines, tag_name)
    range = find_element_by_tag(lines, tag_name)
    return nil unless range

    start_line, end_line = range.split("-").map(&:to_i)
    lines[(start_line - 1)..(end_line - 1)].join
  end

  def extract_element_by_id(lines, tag_pattern, id)
    range = find_element_by_id(lines, tag_pattern, id)
    return nil unless range

    start_line, end_line = range.split("-").map(&:to_i)
    lines[(start_line - 1)..(end_line - 1)].join
  end

  def extract_element_by_class(lines, tag_pattern, class_name)
    range = find_element_by_class(lines, tag_pattern, class_name)
    return nil unless range

    start_line, end_line = range.split("-").map(&:to_i)
    lines[(start_line - 1)..(end_line - 1)].join
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

    # Check if it's a self-closing tag
    if lines[start_line - 1].match(self_closing_pattern)
      return "#{start_line}-#{start_line}"
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

    "#{start_line}-#{end_line}"
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

    # Check if it's a self-closing tag
    if lines[start_line - 1].match(/<#{Regexp.escape(actual_tag)}[^>]*\/>/i)
      return "#{start_line}-#{start_line}"
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

    "#{start_line}-#{end_line}"
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

    # Check if it's a self-closing tag
    if lines[start_line - 1].match(/<#{Regexp.escape(actual_tag)}[^>]*\/>/i)
      return "#{start_line}-#{start_line}"
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

    "#{start_line}-#{end_line}"
  end

  def test_element_filtering(code)
    puts "Testing element filtering with @lang = #{@lang}"
    puts "Elements spec: #{@highlight_options[:elements]}"

    if @highlight_options[:elements] && @lang == "html"
      puts "✓ Condition met - applying element filtering"
      filtered_code = filter_by_elements(code, @highlight_options[:elements])
      return filtered_code if filtered_code
    else
      puts "✗ Condition not met - skipping element filtering"
      puts "  @highlight_options[:elements] = #{@highlight_options[:elements].inspect}"
      puts "  @lang = #{@lang.inspect}"
    end

    code
  end
end

# Test with the HTML file
html_content = File.read("test.html")

puts "Original HTML:"
puts "=" * 50
puts html_content
puts "\n"

# Test extracting style element
puts "Test 1: Extracting style element"
puts "=" * 50
tag = MockExampleTag.new("style")
result = tag.test_element_filtering(html_content)
puts result
puts "\n"

# Test extracting multiple elements
puts "Test 2: Extracting style and script elements"
puts "=" * 50
tag = MockExampleTag.new("style,script")
result = tag.test_element_filtering(html_content)
puts result
puts "\n"

# Test extracting by ID
puts "Test 3: Extracting p#intro element"
puts "=" * 50
tag = MockExampleTag.new("p#intro")
result = tag.test_element_filtering(html_content)
puts result
