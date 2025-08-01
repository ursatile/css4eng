#!/usr/bin/env ruby

# Debug version with logging
class DebugExtractor
  def find_element_by_tag(lines, tag_name)
    tag_pattern = Regexp.escape(tag_name)
    opening_pattern = /<#{tag_pattern}(?:\s[^>]*)?>/i
    closing_pattern = /<\/#{tag_pattern}>/i
    self_closing_pattern = /<#{tag_pattern}[^>]*\/>/i

    puts "Searching for tag: #{tag_name}"
    puts "Opening pattern: #{opening_pattern}"
    puts "Closing pattern: #{closing_pattern}"

    start_line = nil
    lines.each_with_index do |line, index|
      if line.match(opening_pattern) || line.match(self_closing_pattern)
        start_line = index + 1  # Convert to 1-based indexing
        puts "Found opening tag on line #{start_line}: #{line.strip}"
        break
      end
    end

    return nil unless start_line

    # Check if it's a self-closing tag (no content to extract)
    if lines[start_line - 1].match(self_closing_pattern)
      puts "Self-closing tag detected"
      return nil  # Self-closing tags have no content
    end

    # Find the closing tag - start searching from the line after the opening tag
    end_line = start_line
    nest_count = 1  # We already found one opening tag
    puts "Starting search for closing tag from line #{start_line + 1}"

    lines[start_line..-1].each_with_index do |line, relative_index|
      actual_line_num = start_line + relative_index + 1  # +1 because we're showing 1-based line numbers
      puts "Checking line #{actual_line_num}: #{line.strip}"

      # Count opening tags (for nested elements of same type)
      opening_matches = line.scan(opening_pattern).length
      nest_count += opening_matches
      if opening_matches > 0
        puts "  Found #{opening_matches} opening tag(s), nest_count now: #{nest_count}"
      end

      # Count closing tags
      closing_matches = line.scan(closing_pattern).length
      nest_count -= closing_matches
      if closing_matches > 0
        puts "  Found #{closing_matches} closing tag(s), nest_count now: #{nest_count}"
      end

      if nest_count == 0
        end_line = start_line + relative_index
        puts "Found closing tag on line #{end_line}"
        break
      end
    end

    puts "Tag range: #{start_line} to #{end_line}"

    # Return the range INSIDE the tags (excluding opening and closing lines)
    content_start = start_line + 1  # Line after opening tag
    content_end = end_line - 1      # Line before closing tag

    puts "Content range: #{content_start} to #{content_end}"

    # If there's no content between tags, return nil
    if content_start > content_end
      puts "No content between tags"
      return nil
    end

    "#{content_start}-#{content_end}"
  end
end

# Test with the problematic script tag
html_content = File.read("test_content.html")
lines = html_content.lines

puts "Testing script tag extraction:"
puts "=" * 50

extractor = DebugExtractor.new
result = extractor.find_element_by_tag(lines, "script")
puts "Final result: #{result}"
