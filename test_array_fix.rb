#!/usr/bin/env ruby

# Test the array handling fix
class TestArrayFix
  def get_line_range_from_elements(code, elements_spec)
    # Handle both string and array inputs
    selectors = elements_spec.is_a?(Array) ? elements_spec : elements_spec.split(",").map(&:strip)

    puts "Elements spec: #{elements_spec.inspect}"
    puts "Selectors: #{selectors.inspect}"
    puts "Selectors type: #{selectors.class}"

    # Just return a dummy result for testing
    "5-11"
  end
end

test = TestArrayFix.new

puts "Testing with string input:"
result = test.get_line_range_from_elements("dummy code", "style,body")
puts "Result: #{result}\n"

puts "Testing with array input (how Jekyll parses it):"
result = test.get_line_range_from_elements("dummy code", ["style", "body"])
puts "Result: #{result}\n"

puts "Testing with single element string:"
result = test.get_line_range_from_elements("dummy code", "style")
puts "Result: #{result}\n"

puts "Testing with single element array:"
result = test.get_line_range_from_elements("dummy code", ["style"])
puts "Result: #{result}"
