# Frozen-string-literal: true
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

module Jekyll
  class Site
    attr_accessor :reloader
    require_relative "reload/hooks/server"
    require_relative "reload/hooks/reaction"
    require_relative "reload/plugins/jekyll/assets/hook"
    require_relative "reload/hooks/config"
    require_relative "reload/tag"
  end
end
