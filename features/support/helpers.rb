require 'aruba/cucumber'
require 'methadone/cucumber'
require 'vcr'
require 'gataloger'
require 'json'
require 'base64'
require 'aruba'
require 'byebug'

def all_plugins
  @all_plugins ||= Dir[File.expand_path("plugins/*")].map {|path| File.basename(path).split("-",2).last.to_sym}
end

def run_with_options config = {}
  plugins = config.fetch(:plugins, {})
  default_enable = plugins.none?

  config[:paths] = {
          output: expand_path("output"),
          cache: expand_path("cache")
        }
  config[:plugins] = Hash[all_plugins.map {|plugin| [plugin, plugins.fetch(plugin,default_enable)] }]
  @config = config

  run_simple "gataloger " + Base64.urlsafe_encode64(JSON.dump(config))
end

def read_output filename
  CSV.foreach(expand_path(filename), col_sep: "\t", headers: true) do |row|
    yield row
  end
end

RSpec::Matchers.define :output_include do |*expected|
  match do |actual|
    read_output(actual) do |data|
      expected.delete(data.values_at)
    end
    expected.empty?
  end

  failure_message do |actual|
    "expected that #{actual} include lines with #{expected.to_s}"
  end

  not_expected = nil
  match_when_negated do |*actual|
    not_expected = read_output(actual).select { |data| expected.include?(data.values_at) } .first
    not_expected.nil?
  end

  failure_message_when_negated do |actual|
    "expected that #{actual} don't include lines with #{not_expected.to_s}"
  end
end