# Frozen-string-literal: true
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "jekyll/reload/version"

Gem::Specification.new do |s|
  s.require_paths = ["lib"]
  s.authors = ["Jordon Bedwell"]
  s.version = Jekyll::Reload::VERSION
  s.homepage = "http://github.com/anomaly/jekyll-reload/"
  s.files = %w(Rakefile Gemfile README.md LICENSE) + Dir["lib/**/*"]
  s.summary = "Reload your content when Jekyll finishes building."
  s.required_ruby_version = ">= 2.3.0"
  s.email = ["jordon@envygeeks.io"]
  s.license = "Apache-2.0"
  s.name = "jekyll-reload"

  s.add_runtime_dependency("em-websocket", "~> 0.5")
  s.add_runtime_dependency("jekyll", "~> 3.5")
end
