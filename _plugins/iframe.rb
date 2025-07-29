# frozen_string_literal: true

module Jekyll
  module Tags
    class IframeTag < Liquid::Tag
      include Liquid::StandardFilters

      SYNTAX = %r!^([a-zA-Z0-9.+#_-]+)((\s+\w+(=(\w+|"[^"]*"))?)*)$!.freeze

      def initialize(tag_name, markup, tokens)
        super
        if markup.strip =~ SYNTAX
          @filename = Regexp.last_match(1).downcase
          @html_attributes = Regexp.last_match(2)
        else
          @syntax_error = <<~MSG
            Syntax Error in tag 'iframe' while parsing the following markup:
            <pre>#{markup}</pre>
            Valid syntax: {% iframe <filename> [style="height: 10em;" id="my-iframe" attribute="value1 value2 value3"] %}
          MSG
        end
      end

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
          output = %(
<figure class="iframe">
<iframe src="./examples/#{page_filename}/#{expanded_path}" #{@html_attributes}></iframe>
<figcaption><a href="./examples/#{page_filename}/#{expanded_path}">#{@filename}</a></figcaption>
</figure>)
          return output
        rescue => e
          %(<div style="background-color: red; color: white; padding: 10px; border: 2px solid white;">
          <div>⚠️ #{page["path"]}</div>
          #{h(e.class.name + ": " + e.message)}
          </div>)
        end
      end
    end
  end
end

Liquid::Template.register_tag("iframe", Jekyll::Tags::IframeTag)
