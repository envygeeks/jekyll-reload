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

      # --
      def dispatch(data)
        parser = Http::Parser.new.tap { |o| o << data }
        return super if parser.http_method != "GET" || parser.upgrade?
        URI.parse(parser.request_url).path == "/livereload.js" \
          ? do_200 : do_404
      end

      # --
      def do_404
        send_data(request_headers(content, status: 404))
        close_connection true
      end

      # --
      def do_200
        content = Pathutil.new(__dir__).join("vendor", "livereload.js")
        send_data(request_headers(content, status: 200))
        stream_file_data(content).callback do
          close_connection true
        end
      end

      # --
      # Tries to grab the error page content.
      # If there is not error_page, or error_page is not found,
      #   it will return "", a blank page.
      # --
      private
      def content
        @content ||= begin
          path = config["error_page"]; return "" unless path
          site.pages.find { |v| v.path == path }.tap do |v|
            v ? v.output : ""
          end
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
