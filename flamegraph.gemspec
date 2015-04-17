# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flamegraph/version'

Gem::Specification.new do |spec|
  spec.name          = "flamegraph"
  spec.version       = Flamegraph::VERSION
  spec.authors       = ["Sam Saffron"]
  spec.email         = ["sam.saffron@gmail.com"]
  spec.description   = %q{Flamegraph support for arbitrary ruby apps}
  spec.summary       = %q{Flamegraph support for arbitrary ruby apps}
  spec.homepage      = "https://github.com/SamSaffron/flamegraph"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "fast_stack"
end
