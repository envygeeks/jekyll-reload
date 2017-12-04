# Frozen-string-literal: true
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

require_relative "server"
require "eventmachine"

module Jekyll
  module Reload
    class Reactor
      attr_reader :jekyll, :wsc
      extend Forwardable::Extended
      rb_delegate :disconnect, {
        to: :@wsc, alias_of: :delete
      }

      # --
      def initialize(jekyll)
        @jekyll, @wsc = jekyll, []
      end

      # --
      def stop
        @thread&.kill
        Jekyll.logger.debug("Reloader:",
          "stopped")
      end

      # --
      def running?
        @thread&.alive?
      end

      # --
      def start
        Thread.abort_on_exception = true
        @thread = Thread.new do
          EventMachine.run do
            o = {
              jekyll: jekyll,
            }

            a = jekyll.config["reloader"].values_at("host", "port")
            Jekyll.logger.info("Reloader at: ", "http://#{a[0]}:#{a[1]}")
            EventMachine.start_server(a[0], a[1], Server, o) do |w|
              w.onclose   { |_| disconnect(w) }
              w.onopen    { |v| connect(w, v) }
            end
          end
        end
      end

      # --
      def reload
        Jekyll.logger.debug("Reloader: ", "reloaded at #{Time.now}")
        paths.map do |v|
          @wsc.each do |sv|
            sv.send(JSON.dump({
              liveCSS: true,
              command: "reload",
              path: v,
            }))
          end
        end
      end

      # --
      def paths
        (jekyll.pages + jekyll.posts.docs + jekyll.documents)
          .uniq.map(&:path)
      end

      # --
      private
      def connect(ws, v)
        msg = +"Browser Connected".green
        msg << " from origin #{v.headers['Origin'].yellow}"
        Jekyll.logger.debug("Reloader: ", msg)

        ws.send(JSON.dump({
          serverName: "Jekyll Reload v#{VERSION}",
          command: "hello",
          protocols: [
            "http://livereload.com/protocols/official-7",
          ],
        }))

        @wsc << ws
      end
    end
  end
end
