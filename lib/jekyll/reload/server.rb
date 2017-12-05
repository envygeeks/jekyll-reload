# Frozen-string-literal: true
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

require "forwardable/extended"
require "em-websocket"

module Jekyll
  module Reload
    class Server < EventMachine::WebSocket::Connection
      extend Forwardable::Extended

      rb_delegate :jekyll_config, to: :jekyll, alias_of: :config
      rb_delegate :config, to: :jekyll_config, type: :hash, key: "reloader"
      rb_delegate :jekyll, to: :@options, type: :hash
      PATH = "/livereload.js"

      # --
      def dispatch(data)
        parser = Http::Parser.new.tap { |o| o << data }
        return super if parser.http_method != "GET" \
          || parser.upgrade?

        path = URI.parse(parser.request_url)
        return do_jekyll_asset_200(path) if asset?(path)
        path.path == PATH ? do_200 : do_404
      end

      # --
      # Serve from Jekyll-Assets.
      # @example {% asset livereload.js %}
      # @note You can override our vendor'd LiveReload.js
      #   with your own, if you put it in your `_assets/js` folder.
      # --
      def do_jekyll_asset_200(path)
        sha = CGI.parse(path.query).fetch("sha").first
        content = Pathutil.new(jekyll.in_dest_dir(jekyll.sprockets.prefix_url))
        content = content.join(path.path).expand_path
        content = content.sub_ext("-#{sha}.js")

        if content.in_path?(jekyll.in_dest_dir)
          complete_with(content, {
            status: 200,
          })
        else
          do_404
        end
      end

      # --
      def do_404
        complete_with(err_content, {
          status: 404,
        })
      end

      # --
      def do_200
        content = Pathutil.new(__dir__).join("vendor", "livereload.js")
        complete_with(content, {
          status: 200,
        })
      end

      # --
      def asset?(path)
        return false unless path.query
        CGI.parse(path.query).key?("sha") &&
          path.path == PATH
      end

      # --
      # Tries to grab the error page content.
      # If there is not error_page, or error_page is not found,
      #   it will return "", a blank page.
      # --
      private
      def err_content
        @content ||= begin
          path = config["error_page"]; return "" unless path
          site.pages.find { |v| v.path == path }.tap do |v|
            v ? v.output : ""
          end
        end
      end

      # --
      def complete_with(content, status: 200)
        send_data(request_headers(content, status: status))
        stream_file_data(content).callback do
          close_connection true
        end
      end

      # --
      private
      def request_headers(content, status: 200)
        size = content.respond_to?(:bytesize) ?
          content.bytesize : content.size

        out = [
          status_for(status),
          "Content-Length: #{size}",
          "Content-Type: text/html",
          "", ""
        ]

        out.join("\r\n")
      end

      # --
      private
      def status_for(status = 200)
        case status
        when 200 then "HTTP/1.1 200 OK"
        when 401 then "HTTP/1.1 401 UNAUTHORIZED"
        when 403 then "HTTP/1.1 403 FORBIDDEN"
        when 404 then "HTTP/1.1 404 NOT FOUND"
        when 500 then "HTTP/1.1 500 ERROR"
        else
          "HTTP/1.1 400 BAD REQUEST"
        end
      end
    end
  end
end
