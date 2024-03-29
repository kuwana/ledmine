# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ledmine/version'

Gem::Specification.new do |spec|
  spec.name          = "ledmine"
  spec.version       = Ledmine::VERSION
  spec.authors       = ["sankitch"]
  spec.email         = ["i@sankitch.me"]
  spec.description   = %q{Redmine client for lazy.}
  spec.summary       = %q{Redmine client for lazy.}
  spec.homepage      = "http://www.sankitch.me/ledmine/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.default_executable = "ledmine"
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "thor"
  spec.add_dependency "json_pure"
end
