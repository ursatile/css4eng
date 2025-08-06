# frozen_string_literal: true

module Jekyll
  module Tags
    class DiffTag < Liquid::Tag
      include Liquid::StandardFilters

      # SYNTAX = %r!^([a-zA-Z0-9.+#_-]+)((\s+\w+(=(\w+|"([0-9]+\s)*[0-9]+"))?)*)$!.freeze
      SYNTAX = %r!^([a-zA-Z0-9.+#_-]+)((\s+\w+(=(\w+|"[^"]*"))?)*)$!.freeze

      def initialize(tag_name, markup, tokens)
        super
        if markup.strip =~ SYNTAX
          @filename = Regexp.last_match(1).downcase
          @highlight_options = parse_options(Regexp.last_match(2))
          @baseline_filename = @highlight_options[:diff_baseline]
        else
          @syntax_error = <<~MSG
            Syntax Error in tag 'diff' while parsing the following markup:

            <pre>#{markup}</pre>

            Valid syntax: diff <filename> [diff_baseline="baseline_filename"] [diff_mode="mark"] [mark_lines="3, 4, 5"] [iframe_style[="height: 10em;"]] [only_lines="4-6"] [start_after="<style>" end_before="</style>"] [elements="style,body"]
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
        #begin
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

        # Handle baseline file for diff functionality
        baseline_code = nil
        if @baseline_filename
          baseline_path = File.join(root_path, "examples", page_filename, @baseline_filename)
          baseline_code = read_or_create_file(baseline_path, context) if File.exist?(baseline_path)
        end

        # Determine the file language first
        @lang = File.extname(file_path).delete_prefix(".")

        # Step 1: Determine which lines to keep from the original code (before highlighting)
        lines_to_keep = nil

        # Step 1: Determine which lines to keep from the original code (before highlighting)
        lines_to_keep = nil
        element_filtering_applied = false

        # Check for element filtering first
        if @highlight_options[:elements] && @lang == "html"
          lines_to_keep = get_line_ranges_from_elements(code, @highlight_options[:elements])
          element_filtering_applied = true if lines_to_keep
        end

        # Check for pattern-based filtering if no element filtering was applied
        if !lines_to_keep && @highlight_options[:start_after] && @highlight_options[:end_before]
          lines_to_keep = get_line_range_from_patterns(code, @highlight_options[:start_after], @highlight_options[:end_before])
        end

        # Check for only_lines filtering if no other filtering was applied
        if !lines_to_keep && @highlight_options[:only_lines]
          lines_to_keep = @highlight_options[:only_lines]
        end

        # Step 2: Apply syntax highlighting to the ENTIRE code
        output = render_rouge(code)

        # Step 3: Extract only the lines we determined in step 1
        if lines_to_keep
          output = filter_highlighted_lines_for_elements(output, lines_to_keep)
        end

        # Step 4: Apply diff filtering if baseline file is specified
        if @baseline_filename && baseline_code
          # Apply same filtering to baseline code if needed
          filtered_baseline = baseline_code
          if lines_to_keep
            # Apply same line filtering to baseline for fair comparison
            if lines_to_keep.is_a?(Array)
              # Handle element filtering
              filtered_baseline_lines = []
              lines_to_keep.each do |range|
                if range =~ /^(\d+)-(\d+)$/
                  start_line = Regexp.last_match(1).to_i
                  end_line = Regexp.last_match(2).to_i
                  start_index = [start_line - 1, 0].max
                  end_index = [end_line - 1, baseline_code.lines.length - 1].min
                  if start_index <= end_index && start_index < baseline_code.lines.length
                    filtered_baseline_lines.concat(baseline_code.lines[start_index..end_index])
                  end
                end
              end
              filtered_baseline = filtered_baseline_lines.join
            else
              # Handle single range filtering
              filtered_baseline = filter_lines(baseline_code, lines_to_keep)
            end
          end

          # Check diff mode
          if @highlight_options[:diff_mode] == "mark"
            # Mark mode: show entire file but highlight differing lines
            diff_line_numbers = find_diff_line_numbers(code, baseline_code, lines_to_keep)
            unless diff_line_numbers.empty?
              # Add diff line numbers to existing mark_lines
              existing_marks = @highlight_options[:mark_lines] || []
              existing_marks = [existing_marks] unless existing_marks.is_a?(Array)
              @highlight_options[:mark_lines] = existing_marks + diff_line_numbers
              # Re-render with the diff lines marked
              output = render_rouge(code)
              if lines_to_keep
                output = filter_highlighted_lines_for_elements(output, lines_to_keep)
              end
            end
          else
            # Default mode: show only differing lines
            # Apply syntax highlighting to baseline
            baseline_highlighted = render_rouge(filtered_baseline)
            
            # Calculate diff and filter output to show only changed lines
            output = filter_diff_lines(output, baseline_highlighted)
          end
        end

        # Remove common indentation from the filtered output
        # Skip this for element filtering since each block is already dedented individually
        # Also skip for diff processing since we want to preserve original indentation context
        unless element_filtering_applied || (@baseline_filename && baseline_code)
          output = remove_common_indentation(output)
        end

        rendered_output = add_code_tag(output, expanded_path, "examples/#{page_filename}/#{expanded_path}")
        output = prefix + rendered_output + suffix
        if @highlight_options[:iframe_style]
          output += %(<iframe src="./examples/#{page_filename}/#{expanded_path}" style="#{@highlight_options[:iframe_style]}"></iframe>)
        end
        return output
        # rescue => e
        #   %(<div style="background-color: red; color: white; padding: 10px; border: 2px solid white;">
        #   <div>⚠️ #{page["path"]}</div>
        #   #{h(e.class.name + ": " + e.message)}
        #   </div>)
        # end
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
        # Handle both string and array inputs
        selectors = elements_spec.is_a?(Array) ? elements_spec : elements_spec.split(",").map(&:strip)

        # Find all matching elements and extract their content
        matched_content = []

        selectors.each do |selector|
          element_content = extract_element_by_selector(code, selector.strip)
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

      def get_line_ranges_from_elements(code, elements_spec)
        # Handle both string and array inputs
        selectors = elements_spec.is_a?(Array) ? elements_spec : elements_spec.split(",").map(&:strip)

        # Find all matching elements and their line numbers
        matching_ranges = []

        selectors.each do |selector|
          range = find_element_line_range_by_selector(code, selector.strip)
          matching_ranges << range if range  # Only add non-nil ranges
        end

        return nil if matching_ranges.empty?

        # Return array of ranges instead of single combined range
        matching_ranges
      end

      def filter_highlighted_lines_for_elements(highlighted_html, line_ranges)
        return highlighted_html unless line_ranges.is_a?(Array)

        # Split the highlighted HTML by lines, preserving HTML tags
        lines = highlighted_html.split(/(?<=\n)/)

        # Extract content for each range and remove indentation from each block individually
        extracted_content = []

        line_ranges.each do |range|
          if range =~ /^(\d+)-(\d+)$/
            start_line = Regexp.last_match(1).to_i
            end_line = Regexp.last_match(2).to_i

            # Convert to 0-based indexing and ensure valid range
            start_index = [start_line - 1, 0].max
            end_index = [end_line - 1, lines.length - 1].min

            if start_index <= end_index && start_index < lines.length
              block_content = lines[start_index..end_index].join
              # Remove indentation from this block individually
              dedented_block = remove_common_indentation(block_content)
              extracted_content << dedented_block
            end
          end
        end

        return extracted_content.join("\n<hr>\n") unless extracted_content.empty?
        "<span class=\"c1\"># No content found for specified elements</span>\n"
      end

      def get_line_range_from_elements(code, elements_spec)
        # Handle both string and array inputs
        selectors = elements_spec.is_a?(Array) ? elements_spec : elements_spec.split(",").map(&:strip)

        # Find all matching elements and their line numbers
        matching_ranges = []

        selectors.each do |selector|
          range = find_element_line_range_by_selector(code, selector.strip)
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
            end_line = start_line + relative_index + 1  # +1 to convert back to 1-based indexing
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
            end_line = start_line + relative_index + 1  # +1 to convert back to 1-based indexing
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
            end_line = start_line + relative_index + 1  # +1 to convert back to 1-based indexing
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

      def filter_diff_lines(current_highlighted, baseline_highlighted)
        require 'diff/lcs'
        require 'set'
        
        # Split both highlighted versions into lines
        current_lines = current_highlighted.split(/(?<=\n)/)
        baseline_lines = baseline_highlighted.split(/(?<=\n)/)

        # Extract plain text content for comparison (remove HTML tags)
        current_text_lines = current_lines.map { |line| line.gsub(/<[^>]*>/, '') }
        baseline_text_lines = baseline_lines.map { |line| line.gsub(/<[^>]*>/, '') }

        # Use diff-lcs to get structured diff information
        diffs = Diff::LCS.diff(baseline_text_lines, current_text_lines)
        
        if diffs.empty?
          return "<span class=\"c1\"># No differences found compared to baseline</span>\n"
        end

        # Collect changed line numbers in the current (new) file
        changed_lines = Set.new
        
        diffs.each do |hunk|
          hunk.each do |change|
            case change.action
            when '+' # Line added in new file
              # Check if this is a real content change or just whitespace
              current_line = current_text_lines[change.position] || ""
              baseline_line = baseline_text_lines[change.position] || ""
              
              # Normalize whitespace for comparison
              current_normalized = current_line.gsub(/\s+/, ' ').strip
              baseline_normalized = baseline_line.gsub(/\s+/, ' ').strip
              
              # Only mark as changed if content actually differs
              if current_normalized != baseline_normalized
                changed_lines << change.position
              end
            when '!' # Line changed
              # Check if this is a real content change or just whitespace
              current_line = current_text_lines[change.position] || ""
              baseline_line = baseline_text_lines[change.position] || ""
              
              # Normalize whitespace for comparison
              current_normalized = current_line.gsub(/\s+/, ' ').strip
              baseline_normalized = baseline_line.gsub(/\s+/, ' ').strip
              
              # Only mark as changed if content actually differs
              if current_normalized != baseline_normalized
                changed_lines << change.position
              end
            # Note: we don't track '-' (deletions) since they don't exist in the current file
            end
          end
        end

        # Convert to sorted array
        changed_indices = changed_lines.to_a.sort
        
        if changed_indices.empty?
          return "<span class=\"c1\"># No differences found compared to baseline</span>\n"
        end

        # Group into contiguous ranges
        ranges = []
        current_range_start = changed_indices.first
        current_range_end = changed_indices.first

        changed_indices.each_with_index do |line_idx, i|
          if i == 0
            next # Already handled first element
          end
          
          if line_idx == changed_indices[i-1] + 1
            # Consecutive line - extend current range
            current_range_end = line_idx
          else
            # Gap found - close current range and start new one
            ranges << [current_range_start, current_range_end]
            current_range_start = line_idx
            current_range_end = line_idx
          end
        end
        
        # Add the final range
        ranges << [current_range_start, current_range_end]

        # Extract lines for each contiguous range
        result_lines = []
        ranges.each_with_index do |(start_idx, end_idx), range_i|
          # Add all lines in this contiguous range
          (start_idx..end_idx).each do |i|
            if i < current_lines.length
              result_lines << current_lines[i]
            end
          end
          
          # Add separator between ranges (but not after the last one)
          if range_i < ranges.length - 1
            result_lines << "\n"
          end
        end

        result_lines.join
      end

      def find_diff_line_numbers(current_code, baseline_code, lines_to_keep)
        require 'diff/lcs'
        require 'set'
        
        # Apply same filtering to both files for fair comparison
        current_text = current_code
        baseline_text = baseline_code
        
        if lines_to_keep
          if lines_to_keep.is_a?(Array)
            # Handle element filtering - extract same ranges from both files
            current_filtered_lines = []
            baseline_filtered_lines = []
            lines_to_keep.each do |range|
              if range =~ /^(\d+)-(\d+)$/
                start_line = Regexp.last_match(1).to_i
                end_line = Regexp.last_match(2).to_i
                start_index = [start_line - 1, 0].max
                
                # Extract from current file
                current_end_index = [end_line - 1, current_code.lines.length - 1].min
                if start_index <= current_end_index && start_index < current_code.lines.length
                  current_filtered_lines.concat(current_code.lines[start_index..current_end_index])
                end
                
                # Extract from baseline file
                baseline_end_index = [end_line - 1, baseline_code.lines.length - 1].min
                if start_index <= baseline_end_index && start_index < baseline_code.lines.length
                  baseline_filtered_lines.concat(baseline_code.lines[start_index..baseline_end_index])
                end
              end
            end
            current_text = current_filtered_lines.join
            baseline_text = baseline_filtered_lines.join
          else
            # Handle single range filtering
            current_text = filter_lines(current_code, lines_to_keep)
            baseline_text = filter_lines(baseline_code, lines_to_keep)
          end
        end

        # Split into lines for comparison
        current_lines = current_text.lines
        baseline_lines = baseline_text.lines

        # Use diff-lcs to find differences
        diffs = Diff::LCS.diff(baseline_lines, current_lines)
        
        changed_lines = Set.new
        
        diffs.each do |hunk|
          hunk.each do |change|
            case change.action
            when '+' # Line added in current file
              # Check if this is a real content change or just whitespace
              current_line = current_lines[change.position] || ""
              baseline_line = baseline_lines[change.position] || ""
              
              # Normalize whitespace for comparison
              current_normalized = current_line.gsub(/\s+/, ' ').strip
              baseline_normalized = baseline_line.gsub(/\s+/, ' ').strip
              
              # Only mark as changed if content actually differs
              if current_normalized != baseline_normalized
                changed_lines << (change.position + 1) # Convert to 1-based line numbers
              end
            when '!' # Line changed
              # Check if this is a real content change or just whitespace
              current_line = current_lines[change.position] || ""
              baseline_line = baseline_lines[change.position] || ""
              
              # Normalize whitespace for comparison
              current_normalized = current_line.gsub(/\s+/, ' ').strip
              baseline_normalized = baseline_line.gsub(/\s+/, ' ').strip
              
              # Only mark as changed if content actually differs
              if current_normalized != baseline_normalized
                changed_lines << (change.position + 1) # Convert to 1-based line numbers
              end
            end
          end
        end

        # If we applied filtering, we need to map back to original line numbers
        if lines_to_keep && lines_to_keep.is_a?(Array)
          # For element filtering, map the relative positions back to absolute line numbers
          mapped_lines = Set.new
          current_offset = 0
          
          lines_to_keep.each do |range|
            if range =~ /^(\d+)-(\d+)$/
              range_start = Regexp.last_match(1).to_i
              range_end = Regexp.last_match(2).to_i
              range_size = range_end - range_start + 1
              
              # Check if any changed lines fall in this range
              changed_lines.each do |line_num|
                if line_num > current_offset && line_num <= current_offset + range_size
                  # Map back to original line number
                  original_line = range_start + (line_num - current_offset - 1)
                  mapped_lines << original_line
                end
              end
              
              current_offset += range_size
            end
          end
          
          changed_lines = mapped_lines
        elsif lines_to_keep
          # For single range filtering, adjust line numbers
          if lines_to_keep =~ /^(\d+)-(\d+)$/
            offset = Regexp.last_match(1).to_i - 1
            adjusted_lines = Set.new
            changed_lines.each do |line_num|
              adjusted_lines << (line_num + offset)
            end
            changed_lines = adjusted_lines
          end
        end

        changed_lines.to_a.sort
      end

      def add_code_tag(code, name, href)
        code_attrs = %(class="language-#{@lang.tr("+", "-")}" data-lang="#{@lang}")
        %(<figure class="highlight"><pre><code #{code_attrs}>#{code.chomp}</code></pre>
				<figcaption><a href="#{href}">#{name}</a></figcaption></figure>)
      end
    end
  end
end

Liquid::Template.register_tag("diff", Jekyll::Tags::DiffTag)
