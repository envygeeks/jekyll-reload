# Frozen-string-literal: true
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

require "jekyll"

Jekyll::Hooks.register :site, :post_write, priority: :high do |s|
  if Jekyll.env == "development" && s.reloader
    s.reloader.reload
  end
end
