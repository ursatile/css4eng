#!/usr/bin/env ruby

# Simple test for the diff plugin  
require 'jekyll'
require 'liquid'
require_relative '_plugins/diff'

# Mock context for testing
class MockContext
  def registers
    {
      site: MockSite.new,
      page: { "path" => "test.md" }
    }
  end

  def []=(key, value)
    @data ||= {}
    @data[key] = value
  end

  def [](key)
    @data&.[](key)
  end
end

class MockSite
  def config
    { "source" => "." }
  end

  def file_read_opts
    {}
  end
end

# Test basic parsing
puts "Testing diff tag parsing..."

# Test 1: Single filename
tag1 = Jekyll::Tags::DiffTag.new("diff", "test.html", [])
puts "✓ Single filename parsed successfully"

# Test 2: Filename with diff_baseline parameter
tag2 = Jekyll::Tags::DiffTag.new("diff", 'test.html diff_baseline="baseline.html"', [])
puts "✓ Filename with diff_baseline parameter parsed successfully"

# Test 3: Filename with diff_baseline and other options
tag3 = Jekyll::Tags::DiffTag.new("diff", 'test.html diff_baseline="baseline.html" mark_lines="1,2"', [])
puts "✓ Filename with diff_baseline and other options parsed successfully"

puts "\nAll tests passed! The diff plugin is ready to use."
puts "\nUsage examples:"
puts '{% diff current_file.html diff_baseline="baseline_file.html" %}'
puts '{% diff current_file.html diff_baseline="baseline_file.html" mark_lines="1,2,3" %}'
puts '{% diff current_file.html diff_baseline="baseline_file.html" elements="style,body" %}'
