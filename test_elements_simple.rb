#!/usr/bin/env ruby

# Extract just the core functionality for testing
class ElementExtractor
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

    # Find the closing tag
    closing_pattern = /<\/#{Regexp.escape(actual_tag)}>/i
    end_line = start_line
    lines[start_line..-1].each_with_index do |line, relative_index|
      if line.match(closing_pattern)
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

    # Find the closing tag
    closing_pattern = /<\/#{Regexp.escape(actual_tag)}>/i
    end_line = start_line
    lines[start_line..-1].each_with_index do |line, relative_index|
      if line.match(closing_pattern)
        end_line = start_line + relative_index
        break
      end
    end

    "#{start_line}-#{end_line}"
  end
end

# Test the functionality
html_content = File.read("test_elements.html")
extractor = ElementExtractor.new

puts "Testing element extraction:"
puts "=" * 50

# Test 1: Extract style element
puts "\n1. Testing elements=\"style\":"
result = extractor.filter_by_elements(html_content, "style")
puts result ? result : "No match found"

# Test 2: Extract body element
puts "\n2. Testing elements=\"body\":"
result = extractor.filter_by_elements(html_content, "body")
puts result ? result : "No match found"

# Test 3: Extract multiple elements
puts "\n3. Testing elements=\"style,script\":"
result = extractor.filter_by_elements(html_content, "style,script")
puts result ? result : "No match found"

# Test 4: Extract element by ID
puts "\n4. Testing elements=\"p#intro\":"
result = extractor.filter_by_elements(html_content, "p#intro")
puts result ? result : "No match found"

# Test 5: Extract element by class
puts "\n5. Testing elements=\"p.highlight\":"
result = extractor.filter_by_elements(html_content, "p.highlight")
puts result ? result : "No match found"
