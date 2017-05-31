# coding: utf-8

REQUIRE_PATHS = ['lib', 'plugins']

REQUIRE_PATHS.each do |folder|
  path = File.expand_path("../#{folder}", __FILE__)
  $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
end

require 'gataloger/version'

Gem::Specification.new do |spec|
  spec.name          = "gataloger"
  spec.version       = Gataloger::VERSION
  spec.authors       = ["leio10"]
  spec.email         = ["informatica at podemos.info"]

  spec.summary       = %q{Geographical data catalog creator}
  spec.homepage      = "https://github.com/podemos-info/gataloger"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = REQUIRE_PATHS

  spec.add_dependency('methadone', '~> 1.9.5')
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('aruba')
  spec.add_development_dependency('test-unit')
  spec.add_development_dependency('rspec', '~> 3')
  spec.add_development_dependency('byebug')
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"

  spec.add_dependency('activesupport', '>= 3.0.0')

  dependencies = {}
  Dir[File.expand_path("../plugins/*/gemspec", __FILE__)].each do |gemspec|
    IO.readlines(gemspec).each do |line|
      next if dependencies[line]
      spec.add_dependency *(line.strip.split(",", 2))
      dependencies[line] = true
    end
  end
end
