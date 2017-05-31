require 'aruba/cucumber'
require 'methadone/cucumber'

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
LIB_DIR = File.join(File.expand_path(File.dirname(__FILE__)),'..','..','lib')

Before do
  # Using "announce" causes massive warnings on 1.9.2
  @puts = true
  @original_rubylib = ENV['RUBYLIB']
  ENV['RUBYLIB'] = LIB_DIR + File::PATH_SEPARATOR + ENV['RUBYLIB'].to_s
end

After do
  ENV['RUBYLIB'] = @original_rubylib
end

require File.expand_path(File.dirname(__FILE__) + '/helpers')

require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = "cache/vcr"
  config.hook_into :webmock
end


require 'gataloger'
require 'json'
require 'base64'
require 'active_support/core_ext/hash'
require 'methadone'

class Runner
  # Allow everything fun to be injected from the outside while defaulting to normal implementations.
  def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = Kernel)
    @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
    $stdout, $stderr = @stdout, @stderr    
  end

  def execute!
    config = JSON.parse(Base64.urlsafe_decode64(@argv[0])).deep_symbolize_keys
    VCR.use_cassette("run") do
      Gataloger::Main.new(config).run
    end
  end
end

require 'aruba/in_process'
Aruba.configure do |config| 
  config.command_launcher = :in_process
  config.main_class = ::Runner
end
