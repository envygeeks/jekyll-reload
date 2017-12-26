# Frozen-string-literal: true
# rubocop:disable Layout/IndentationConsistency
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

require "liquid"

module Jekyll
  module Reload
    # --
    # Provides a liquid tag to load LiveReload.
    #   There is also asset integration.
    # --
    class Tag < Liquid::Tag
      def render(ctx)
        return "" unless Jekyll.env == "development"
        config = ctx.registers[:site].config["reloader"]
        path = "http://#{config['host']}:#{config['port']}/livereload.js"
        a = +"<script type='text/javascript' src='#{path}'>"
          a << "<!-- EMPTY -->"
        a << "</script>"
      end
    end
  end
end

# --
Liquid::Template.register_tag("livereload",
  Jekyll::Reload::Tag)
