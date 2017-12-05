# Frozen-string-literal: true
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

begin
  require "jekyll/assets"; require "jekyll/assets/version"
  if Gem::Version.new(Jekyll::Assets::VERSION) >= Gem::Version.new("3.0")
    require_relative "default"

    Jekyll::Assets::Hook.register :env, :after_init do
      append_path Pathutil.new(__dir__).join("../../../vendor").expand_path.to_s
    end
  end
rescue LoadError
  nil
end
