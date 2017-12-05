# Frozen-string-literal: true
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

begin
  require "jekyll-assets"

  module Jekyll
    module Reload
      class Default < Jekyll::Assets::Default
        content_types "application/javascript"

        def set_src
          config = jekyll.config["reloader"]

          uri.scheme = "http"
          uri.port = config["port"]
          uri.query = "sha=#{asset.hexdigest}"
          uri.hostname = config["host"]
          uri.path = "/livereload.js"
          args[:src] = uri.to_s
        end

        # --
        def self.for?(type:, args:)
          super && args[:argv1] == "livereload.js"
        end

        # --
        private
        def uri
          @uri ||= URI.parse(args[:src])
        end
      end
    end
  end
rescue LoadError
  nil
end
