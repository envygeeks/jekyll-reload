# Frozen-string-literal: true
# Copyright: 2017 - Apache 2.0 License
# rubocop:disable Style/SymbolProc
# Encoding: utf-8

require_relative "../reactor"
require "jekyll"

Jekyll::Hooks.register :site, :post_write, priority: :high do |s|
  next if s.reloader

  if s.config["serving"]
    s.reloader = Jekyll::Reload::Reactor.new(s).tap do |o|
      o.start
    end
  end
end
