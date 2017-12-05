# Frozen-string-literal: true
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

require "jekyll"

begin
  require "jekyll/assets"
  Jekyll::Assets::Hook.register :env, :after_write do
    if Jekyll.env == "development" && jekyll.reloader
      then jekyll.reloader.reload
    end
  end
rescue LoadError
  Jekyll::Hooks.register :site, :post_write, priority: :high do |s|
    if Jekyll.env == "development" && s.reloader
      s.reloader.reload
    end
  end
end
