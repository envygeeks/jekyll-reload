# Frozen-string-literal: true
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

require "jekyll"
def hook
  Jekyll::Hooks.register :site, :post_write, priority: :high do |s|
    if Jekyll.env == "development" && s.reloader
      s.reloader.reload
    end
  end
end

begin
  require "jekyll/assets"; require "jekyll/assets/version"
  if Gem::Version.new(Jekyll::Assets::VERSION) >= Gem::Version.new("3.0")
    Jekyll::Assets::Hook.register :env, :after_write do
      if Jekyll.env == "development" && jekyll.reloader
        then jekyll.reloader.reload
      end
    end
  else
    hook
  end
rescue LoadError
  hook
end
