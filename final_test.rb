#!/usr/bin/env ruby

# Simple test using the actual fixed methods
require_relative "_plugins/example.rb"

# Mock example tag
class TestExample < Jekyll::Tags::ExampleTag
  def initialize
    @highlight_options = {}
  end

  def test_elements(code, elements_spec)
    get_line_range_from_elements(code, elements_spec)
  end
end

html_content = File.read("final_test.html")
tag = TestExample.new

puts "HTML content:"
puts html_content
puts "\nTesting elements='style':"
result = tag.test_elements(html_content, "style")
puts "Result: #{result}"

if result
  lines = html_content.lines
  start_line, end_line = result.split("-").map(&:to_i)
  puts "Lines #{start_line}-#{end_line}:"
  puts lines[(start_line - 1)..(end_line - 1)].join
end

puts "\nTesting elements='script':"
result = tag.test_elements(html_content, "script")
puts "Result: #{result}"

if result
  lines = html_content.lines
  start_line, end_line = result.split("-").map(&:to_i)
  puts "Lines #{start_line}-#{end_line}:"
  puts lines[(start_line - 1)..(end_line - 1)].join
end
