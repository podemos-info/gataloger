module Gataloger
  module Plugins
    def self.available
      @available ||= Dir[File.expand_path("../../../plugins/*", __FILE__)].map {|folder| File.basename(folder).split("-",2)}.sort
    end

    def self.load args
      plugins = args[:plugins] || {}
      default_value = plugins.values.none?
      self.available.each do |order,plugin|
        require "#{order}-#{plugin}/#{plugin}.rb" if plugins.fetch(plugin.to_sym, default_value)
      end
    end

    class Plugin
      @@plugins = []

      def initialize config = {}
        @config = config
      end

      def prepare
      end

      def process data
      end

      def self.to_s
        self.name.gsub(/^.*::/, '').underscore.dasherize
      end

      def self.inherited(plugin)
        @@plugins << plugin
      end

      def self.plugins
        @@plugins
      end
    end

    class FatalError < StandardError
    end
  end
end
