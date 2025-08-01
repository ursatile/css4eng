#!/usr/bin/env ruby

# Quick test for elements bug fix
require_relative "_plugins/example.rb"

# Create a mock context
class MockSite
  def config
    { "source" => "." }
  end

  def file_read_opts
    {}
  end
end

class MockPage
  def initialize(path)
    @path = path
  end

  def [](key)
    @path if key == "path"
  end
end

class MockContext
  def initialize
    @registers = {
      site: MockSite.new,
      page: MockPage.new("test.md"),
    }
  end

  def registers
    @registers
  end

  def [](key)
    nil
  end
end

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

# Create test file
File.write("examples/test/test.html", html_content)

# Test the tag
tag = Jekyll::Tags::ExampleTag.new("example", 'test.html elements="style,body"', [])
context = MockContext.new

puts "Testing elements extraction:"
puts "=" * 50
result = tag.render(context)
puts result
puts "=" * 50

# Clean up
File.delete("examples/test/test.html") if File.exist?("examples/test/test.html")
Dir.rmdir("examples/test") if Dir.exist?("examples/test") && Dir.empty?("examples/test")
Dir.rmdir("examples") if Dir.exist?("examples") && Dir.empty?("examples")
