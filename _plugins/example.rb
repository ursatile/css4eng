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

            Valid syntax: example <filename> [mark_lines="3, 4, 5"] [iframe_style[="height: 10em;"]] [only_lines="4-6"]
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
          
          # Apply only_lines filter if specified
          if @highlight_options[:only_lines]
            code = filter_lines(code, @highlight_options[:only_lines])
          end
          
          @lang = File.extname(file_path).delete_prefix(".")
          output = render_rouge(code)
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
