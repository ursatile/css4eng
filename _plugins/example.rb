# frozen_string_literal: true

module Jekyll
  module Tags
    class ExampleTag < Liquid::Tag
      include Liquid::StandardFilters

      # SYNTAX = %r!^([a-zA-Z0-9.+#_-]+)((\s+\w+(=(\w+|"([0-9]+\s)*[0-9]+"))?)*)$!.freeze
      SYNTAX = %r!^([a-zA-Z0-9.+#_-]+)((\s+\w+(=(\w+|"[^"]*"))?)*)$!.freeze

      def initialize(tag_name, markup, tokens)
        super
        if markup.strip =~ SYNTAX
          @filename = Regexp.last_match(1).downcase
          @highlight_options = parse_options(Regexp.last_match(2))
        else
          @syntax_error = <<~MSG
            Syntax Error in tag 'example' while parsing the following markup:

            <pre>#{markup}</pre>

            Valid syntax: example <filename> [mark_lines="3, 4, 5"] [iframe_style[="height: 10em;"]] [only_lines="4-6"] [start_after="<style>" end_before="</style>"] [elements="style,body"]
          MSG
        end
      end

      def read_or_create_file(path, context)
        unless File.exist?(path)
          title = File.basename(path, ".html").tr("_-", " ").split.map(&:capitalize).join(" ")
          if path.downcase.end_with?(".html")
            puts "#{path} not found - creating with HTML boilerplate"
            File.write(path, <<~HTML)
              <!DOCTYPE html>
              <html lang="en">
              <head>
                <title>#{title}</title>
              </head>
              <body>
              </body>
              </html>
            HTML
          elsif path.downcase.end_with?(".css")
            puts "#{path} not found - creating with CSS boilerplate"
            File.write(path, "html { }")
          elsif File.extname(path).length >= 3
            puts "#{path} not found - creating empty file"
            File.write(path, "")
          end
        end
        file_read_opts = context.registers[:site].file_read_opts
        File.read(path, **file_read_opts)
      end

      LEADING_OR_TRAILING_LINE_TERMINATORS = %r!\A(\n|\r)+|(\n|\r)+\z!.freeze

      def render(context)
        if @syntax_error
          return %(<div style="background-color: red; color: white; padding: 10px; border: 2px solid white;">#{@syntax_error}</div>)
        end
        begin
          prefix = context["highlighter_prefix"] || ""
          suffix = context["highlighter_suffix"] || ""

          page = context.registers[:page]
          parts = @markup.split(" ", 2)
          expanded_path = Liquid::Template.parse(parts[0].strip).render(context)
          page_filename = File.basename(page["path"], ".*")
          root_path = File.expand_path(context.registers[:site].config["source"])
          file_path = File.join(root_path, "examples", page_filename, expanded_path)
          attributes = parts.length > 1 ? parts[1] : "all"
          dir = File.dirname(file_path)
          FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
          code = read_or_create_file(file_path, context)

          # Apply element filtering if specified (before syntax highlighting)
          if @highlight_options[:elements] && @lang == "html"
            filtered_code = filter_by_elements(code, @highlight_options[:elements])
            code = filtered_code if filtered_code
          end

          # Determine line range from patterns if specified
          line_range = nil
          if @highlight_options[:start_after] && @highlight_options[:end_before]
            line_range = get_line_range_from_patterns(code, @highlight_options[:start_after], @highlight_options[:end_before])
          end

          @lang = File.extname(file_path).delete_prefix(".")
          output = render_rouge(code)

          # Apply pattern-based line filtering if we found a range
          if line_range
            output = filter_highlighted_lines(output, line_range)
          end

          # Apply only_lines filter after syntax highlighting if specified
          if @highlight_options[:only_lines]
            output = filter_highlighted_lines(output, @highlight_options[:only_lines])
          end

          # Remove common indentation from the filtered output
          output = remove_common_indentation(output)

          rendered_output = add_code_tag(output, expanded_path, "examples/#{page_filename}/#{expanded_path}")
          output = prefix + rendered_output + suffix
          if @highlight_options[:iframe_style]
            output += %(<iframe src="./examples/#{page_filename}/#{expanded_path}" style="#{@highlight_options[:iframe_style]}"></iframe>)
          end
          return output
        rescue => e
          %(<div style="background-color: red; color: white; padding: 10px; border: 2px solid white;">
          <div>⚠️ #{page["path"]}</div>
          #{h(e.class.name + ": " + e.message)}
          </div>)
        end
      end

      private

      OPTIONS_REGEX = %r!(?:\w="[^"]*"|\w=\w|\w)+!.freeze

      def parse_options(input)
        options = {}
        return options if input.empty?

        # Split along 3 possible forms -- key="<quoted list>", key=value, or key
        input.scan(OPTIONS_REGEX) do |opt|
          key, value = opt.split("=")
          if value&.include?('"')
            value.delete!('"')
            value = value.include?(",") ? value.split(",").map(&:strip) : value.strip
          end
          options[key.to_sym] = value || true
        end

        options[:linenos] = "inline" if options[:linenos] == true
        options
      end

      def render_rouge(code)
        require "rouge"
        formatter = Rouge::Formatters::HTML.new
        formatter = line_highlighter_formatter(formatter) if @highlight_options[:mark_lines]
        lexer = Rouge::Lexer.find_fancy(@lang, code) || Rouge::Lexers::PlainText
        formatter.format(lexer.lex(code))
      end

      def line_highlighter_formatter(formatter)
        Rouge::Formatters::HTMLLineHighlighter.new(
          formatter,
          :highlight_lines => mark_lines,
        )
      end

      def mark_lines
        value = @highlight_options[:mark_lines]
        value = [value] if value.is_a?(String) && value =~ /^\d+$/
        return value.map(&:to_i) if value.is_a?(Array)

        raise SyntaxError, "Syntax Error for mark_lines declaration. Expected a " \
                           "double-quoted list of integers."
      end

      def filter_lines(code, line_range)
        lines = code.lines

        if line_range =~ /^(\d+)-(\d+)$/
          start_line = Regexp.last_match(1).to_i
          end_line = Regexp.last_match(2).to_i

          # Convert to 0-based indexing and ensure valid range
          start_index = [start_line - 1, 0].max
          end_index = [end_line - 1, lines.length - 1].min

          if start_index > end_index || start_index >= lines.length
            return "# No lines found in specified range\n"
          end

          return lines[start_index..end_index].join
        else
          raise SyntaxError, "Syntax Error for only_lines declaration. Expected format: \"start-end\" (e.g., \"4-6\")"
        end
      end

      def filter_by_patterns(code, start_pattern, end_pattern)
        lines = code.lines
        start_index = nil
        end_index = nil

        # Find the start pattern
        lines.each_with_index do |line, index|
          if line.include?(start_pattern)
            start_index = index + 1 # Start from the line AFTER the pattern
            break
          end
        end

        # If start pattern not found, return empty
        return "# Start pattern '#{start_pattern}' not found\n" if start_index.nil?

        # Find the end pattern starting from after the start
        lines[start_index..-1].each_with_index do |line, relative_index|
          if line.include?(end_pattern)
            end_index = start_index + relative_index - 1 # Stop BEFORE the end pattern
            break
          end
        end

        # If end pattern not found, go to end of file
        end_index = lines.length - 1 if end_index.nil?

        # Extract the lines between patterns
        if start_index <= end_index
          lines[start_index..end_index].join
        else
          "# No content found between patterns\n"
        end
      end

      def filter_by_elements(code, elements_spec)
        # Split the elements specification by comma and trim whitespace
        selectors = elements_spec.split(',').map(&:strip)
        
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
        if selector.include?('#')
          # ID selector like "p#example"
          tag, id = selector.split('#', 2)
          tag = tag.empty? ? '[a-zA-Z][a-zA-Z0-9]*' : Regexp.escape(tag)
          extract_element_by_id(lines, tag, id)
        elsif selector.include?('.')
          # Class selector like "div.container"
          tag, class_name = selector.split('.', 2)
          tag = tag.empty? ? '[a-zA-Z][a-zA-Z0-9]*' : Regexp.escape(tag)
          extract_element_by_class(lines, tag, class_name)
        else
          # Simple tag selector like "style" or "body"
          extract_element_by_tag(lines, selector)
        end
      end

      def extract_element_by_tag(lines, tag_name)
        range = find_element_by_tag(lines, tag_name)
        return nil unless range
        
        start_line, end_line = range.split('-').map(&:to_i)
        lines[(start_line - 1)..(end_line - 1)].join
      end

      def extract_element_by_id(lines, tag_pattern, id)
        range = find_element_by_id(lines, tag_pattern, id)
        return nil unless range
        
        start_line, end_line = range.split('-').map(&:to_i)
        lines[(start_line - 1)..(end_line - 1)].join
      end

      def extract_element_by_class(lines, tag_pattern, class_name)
        range = find_element_by_class(lines, tag_pattern, class_name)
        return nil unless range
        
        start_line, end_line = range.split('-').map(&:to_i)
        lines[(start_line - 1)..(end_line - 1)].join
      end

      def get_line_range_from_elements(code, elements_spec)
        # Split the elements specification by comma and trim whitespace
        selectors = elements_spec.split(',').map(&:strip)
        
        # Find all matching elements and their line numbers
        matching_ranges = []
        
        selectors.each do |selector|
          range = find_element_line_range_by_selector(code, selector)
          matching_ranges << range if range
        end
        
        return nil if matching_ranges.empty?
        
        # Find the overall range that encompasses all matching elements
        min_start = matching_ranges.map { |r| r.split('-')[0].to_i }.min
        max_end = matching_ranges.map { |r| r.split('-')[1].to_i }.max
        
        "#{min_start}-#{max_end}"
      end

      def find_element_line_range_by_selector(code, selector)
        lines = code.lines
        
        # Parse different selector types
        if selector.include?('#')
          # ID selector like "p#example"
          tag, id = selector.split('#', 2)
          tag = tag.empty? ? '[a-zA-Z][a-zA-Z0-9]*' : Regexp.escape(tag)
          find_element_by_id(lines, tag, id)
        elsif selector.include?('.')
          # Class selector like "div.container"
          tag, class_name = selector.split('.', 2)
          tag = tag.empty? ? '[a-zA-Z][a-zA-Z0-9]*' : Regexp.escape(tag)
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
        
        # Check if it's a self-closing tag
        if lines[start_line - 1].match(self_closing_pattern)
          return "#{start_line}-#{start_line}"
        end
        
        # Find the closing tag
        end_line = start_line
        lines[start_line..-1].each_with_index do |line, relative_index|
          if line.match(closing_pattern)
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
        actual_tag = match ? match[1] : tag_pattern.gsub(/\[.*?\]/, '') # fallback
        
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
        actual_tag = match ? match[1] : tag_pattern.gsub(/\[.*?\]/, '') # fallback
        
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

      def get_line_range_from_patterns(code, start_pattern, end_pattern)
        lines = code.lines
        start_index = nil
        end_index = nil

        # Find the start pattern
        lines.each_with_index do |line, index|
          if line.include?(start_pattern)
            start_index = index + 2 # Start from the line AFTER the pattern (1-based for filter_highlighted_lines)
            break
          end
        end

        # If start pattern not found, return nil
        return nil if start_index.nil?

        # Find the end pattern starting from after the start
        lines[(start_index - 1)..-1].each_with_index do |line, relative_index|
          if line.include?(end_pattern)
            end_index = start_index + relative_index - 1 # Stop BEFORE the end pattern (1-based)
            break
          end
        end

        # If end pattern not found, go to end of file
        end_index = lines.length if end_index.nil?

        # Return the range in the format expected by filter_highlighted_lines
        if start_index <= end_index
          "#{start_index}-#{end_index}"
        else
          nil
        end
      end

      def filter_highlighted_lines(highlighted_html, line_range)
        if line_range =~ /^(\d+)-(\d+)$/
          start_line = Regexp.last_match(1).to_i
          end_line = Regexp.last_match(2).to_i

          # Split the highlighted HTML by lines, preserving HTML tags
          lines = highlighted_html.split(/(?<=\n)/)

          # Convert to 0-based indexing and ensure valid range
          start_index = [start_line - 1, 0].max
          end_index = [end_line - 1, lines.length - 1].min

          if start_index > end_index || start_index >= lines.length
            return "<span class=\"c1\"># No lines found in specified range</span>\n"
          end

          return lines[start_index..end_index].join
        else
          raise SyntaxError, "Syntax Error for only_lines declaration. Expected format: \"start-end\" (e.g., \"4-6\")"
        end
      end

      def remove_common_indentation(highlighted_html)
        # Split into lines while preserving HTML structure
        lines = highlighted_html.split(/(?<=\n)/)
        return highlighted_html if lines.empty?

        # Find the minimum indentation by looking at non-empty lines
        # We need to extract text content from HTML to measure indentation
        min_indent = nil

        lines.each do |line|
          # Skip empty lines (just whitespace and newlines)
          next if line.strip.empty?

          # Extract text content from HTML to measure leading whitespace
          text_content = line.gsub(/<[^>]*>/, "")
          leading_whitespace = text_content.match(/^(\s*)/)[1]
          indent_count = leading_whitespace.length

          min_indent = indent_count if min_indent.nil? || indent_count < min_indent
        end

        # If no indentation found, return as-is
        return highlighted_html if min_indent.nil? || min_indent == 0

        # Remove the common indentation from each line
        dedented_lines = lines.map do |line|
          if line.strip.empty?
            line
          else
            # Remove the minimum indentation from the beginning of the line
            # We need to be careful with HTML tags at the start
            remove_leading_whitespace(line, min_indent)
          end
        end

        dedented_lines.join
      end

      def remove_leading_whitespace(html_line, spaces_to_remove)
        return html_line if spaces_to_remove <= 0

        # Track how many spaces we've removed
        removed = 0
        result = html_line.dup

        # Process character by character from the beginning
        i = 0
        while i < result.length && removed < spaces_to_remove
          char = result[i]

          if char == "<"
            # Skip over HTML tags
            tag_end = result.index(">", i)
            if tag_end
              i = tag_end + 1
              next
            else
              break
            end
          elsif char == " " || char == "\t"
            # Remove whitespace character
            result[i] = ""
            removed += (char == "\t" ? 8 : 1) # Treat tab as 8 spaces
            # Don't increment i since we removed a character
          else
            # Hit non-whitespace, stop removing
            break
          end
        end

        result
      end

      def render_codehighlighter(code)
        h(code).strip
      end

      def add_code_tag(code, name, href)
        code_attrs = %(class="language-#{@lang.tr("+", "-")}" data-lang="#{@lang}")
        %(<figure class="highlight"><pre><code #{code_attrs}>#{code.chomp}</code></pre>
				<figcaption><a href="#{href}">#{name}</a></figcaption></figure>)
      end
    end
  end
end

Liquid::Template.register_tag("example", Jekyll::Tags::ExampleTag)
