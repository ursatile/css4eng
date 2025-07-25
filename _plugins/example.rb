# frozen_string_literal: true

module Jekyll
  module Tags
    class ExampleTag < Liquid::Tag
      include Liquid::StandardFilters

      def initialize(tag_name, markup, tokens)
        super
        if markup.strip =~ SYNTAX
          @filename = Regexp.last_match(1).downcase
          @highlight_options = parse_options(Regexp.last_match(2))
        else
          raise SyntaxError, <<~MSG
                  Syntax Error in tag 'example' while parsing the following markup:

                  #{markup}

                  Valid syntax: example <filename> [mark_lines="3 4 5"]

                MSG
        end
      end

      def read_file(path, context)
        file_read_opts = context.registers[:site].file_read_opts
        File.read(path, **file_read_opts)
      end

      SYNTAX = %r!^([a-zA-Z0-9.+#_-]+)((\s+\w+(=(\w+|"([0-9]+\s)*[0-9]+"))?)*)$!.freeze

      LEADING_OR_TRAILING_LINE_TERMINATORS = %r!\A(\n|\r)+|(\n|\r)+\z!.freeze

      def render(context)
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

          code = read_file(file_path, context)
          @lang = File.extname(file_path).delete_prefix(".")
          output = render_rouge(code)
          rendered_output = add_code_tag(output, expanded_path, "examples/#{page_filename}/#{expanded_path}")
          prefix + rendered_output + suffix
        rescue => e
          line_number = @options && @options[:line_number] ? @options[:line_number] : "unknown"
          %(<div style="background-color: red; color: white; padding: 10px; border: 2px solid white;">
          <div>⚠️ #{page_filename} line #{line_number}</div>
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
          # If a quoted list, convert to array
          if value&.include?('"')
            value.delete!('"')
            value = value.split
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
        return value.map(&:to_i) if value.is_a?(Array)

        raise SyntaxError, "Syntax Error for mark_lines declaration. Expected a " \
                           "double-quoted list of integers."
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
