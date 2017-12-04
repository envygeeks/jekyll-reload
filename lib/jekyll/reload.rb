# Frozen-string-literal: true
# rubocop:disable Style/BlockDelimiters
# rubocop:disable Layout/MultilineBlockLayout
# rubocop:disable Layout/BlockEndNewline
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

module Jekyll
  class Site
    attr_accessor :reloader
    %i(server reaction config).map { |v| require_relative \
      "reload/hooks/#{v}" }
  end
end
