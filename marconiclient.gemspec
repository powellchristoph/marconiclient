# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marconiclient/version'

Gem::Specification.new do |spec|
  spec.name          = "marconiclient"
  spec.version       = Marconiclient::VERSION
  spec.authors       = ["Chris Powell"]
  spec.email         = ["powellchristoph@gmail.com"]
  spec.summary       = %q{Basic client for the Openstack Marconi queuing service.}
  spec.description   = %q{Basic client for the Openstack Marconi queuing service.}
  spec.homepage      = "https://github.com/powellchristoph/marconiclient"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
