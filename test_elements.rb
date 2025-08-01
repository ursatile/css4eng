#!/usr/bin/env ruby

# Load the example.rb file
require_relative '_plugins/example.rb'

# Read the test HTML
html_content = File.read('test_elements.html')

# Create a mock example tag instance
class TestExampleTag < Jekyll::Tags::ExampleTag
  def initialize
    @highlight_options = {}
  end
  
  def test_filter_by_elements(code, elements_spec)
    filter_by_elements(code, elements_spec)
  end
end

# Test the functionality
test_tag = TestExampleTag.new

puts "Testing element extraction:"
puts "=" * 50

# Test 1: Extract style element
puts "\n1. Testing elements=\"style\":"
result = test_tag.test_filter_by_elements(html_content, "style")
puts result

# Test 2: Extract body element
puts "\n2. Testing elements=\"body\":"
result = test_tag.test_filter_by_elements(html_content, "body")
puts result

# Test 3: Extract multiple elements
puts "\n3. Testing elements=\"style,script\":"
result = test_tag.test_filter_by_elements(html_content, "style,script")
puts result

# Test 4: Extract element by ID
puts "\n4. Testing elements=\"p#intro\":"
result = test_tag.test_filter_by_elements(html_content, "p#intro")
puts result

# Test 5: Extract element by class
puts "\n5. Testing elements=\"p.highlight\":"
result = test_tag.test_filter_by_elements(html_content, "p.highlight")
puts result
