# Frozen-string-literal: true
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

module Jekyll
  # --
  # Patches site and adds our reloader.
  #   This allows us to reuse it.
  # --
  class Site
    attr_accessor :reloader
  end
end
