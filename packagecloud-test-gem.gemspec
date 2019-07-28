# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'packagecloud/test/gem/version'

Gem::Specification.new do |spec|
  spec.name          = "packagecloud-test-gem"
  spec.version       = Packagecloud::Test::Gem::VERSION
  spec.authors       = ["Joe Damato"]
  spec.email         = ["joe@packagecloud.io"]
  spec.description   = %q{a hello world program from the packagecloud crew}
  spec.summary       = %q{a hello world program from the packagecloud crew}
  spec.homepage      = "https://packagecloud.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib", "bin"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
