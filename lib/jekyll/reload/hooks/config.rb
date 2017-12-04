# Frozen-string-literal: true
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

require_relative "../reactor"
require "jekyll"

Jekyll::Hooks.register :site, :after_init, priority: :low do |s|
  s.config["reloader"] ||= {}
  s.config["reloader"]["host"] ||= s.config["host"]
  s.config["reloader"]["error_file"] ||= nil
  s.config["reloader"]["port"] ||= 35_729
end
