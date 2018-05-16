require 'methadone'
require 'gataloger/version'
require 'gataloger/region'
require 'gataloger/plugins'
require 'csv'
require 'fileutils'

module Gataloger
  class Main
    include Methadone::CLILogging

    DEFAULT_LOCALES = 'es ca-es eu-es ga-es en'

    def initialize config
      @config = {
        locales: DEFAULT_LOCALES,
        cache: true,
        paths: {
          output: File.expand_path("output"),
          cache: File.expand_path("cache")
        },
        plugins: {},
        prepare: false
      }.merge(config)

      locales = {}
      @config[:locales].split(" ").each do |locale|
        path = locales
        locale.split("-").reverse.each do |part|
          if path[part]
            path = path[part]
          else
            path = path[part] = {}
          end
        end
      end
      @config[:locales] = locales
      change_logger(Methadone::CLILogger.new)
    end

    def run
      # prepare folders
      @config[:paths].values.each do |path|
        FileUtils.mkdir_p path
      end
      FileUtils.rm Dir["#{@config[:paths][:output]}/*"]

      # load plugins and run process
      Gataloger::Plugins.load @config
      if @config[:prepare]
        prepare 
      else
        process
      end
    end

    private

    def prepare
      info("Preparing plugins:")
      Plugins::Plugin.plugins.each do |plugin|
        plugin.new(@config).prepare
        info "* #{plugin} prepared successfully"
      end
    end

    def process
      regions = Regions.new
      info("Processing plugins:")
      Plugins::Plugin.plugins.each do |plugin|
        plugin.new(@config).process regions
        info "* #{plugin} processed successfully"
      end

      info("Saving data")
      dump(regions)
    end

    def dump regions
      output = @config[:paths][:output]

      CSV.open(output_path("scopes"), "wb", col_sep: "\t", headers: [ "UID", "Type", "Name"], write_headers: true) do |csv|
        regions.each do |region|
          csv << [ region.uid, region.type, region.name ]
        end
      end

      CSV.open(output_path("scopes.mappings"), "wb", col_sep: "\t", headers: [ "UID", "Encoding", "Code"], write_headers: true) do |csv|
        regions.each_mapping do |uid, encoding, code|
          csv << [uid, encoding, code ]
        end
      end

      CSV.open(output_path("scopes.metadata"), "wb", col_sep: "\t", headers: [ "UID", "Key", "Value"], write_headers: true) do |csv|
        regions.each do |region|
          region.metadata.each do |key, value|
            csv << [region.uid, key, value ]
          end
        end
      end

      CSV.open(output_path("scopes.translations"), "wb", col_sep: "\t", headers: [ "UID", "Locale", "Translation"], write_headers: true) do |csv|
        regions.each do |region|
          region.translations.each do |locale, translation|
            csv << [region.uid, locale, translation ]
          end
        end
      end
    end 

    def output_path filename
      File.join("output", "#{filename}.tsv")
    end
  end
end
