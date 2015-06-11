# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hippie_csv/version'

Gem::Specification.new do |spec|
  spec.name          = "hippie_csv"
  spec.version       = HippieCsv::VERSION
  spec.authors       = ["Stephen O'Brien"]
  spec.email         = ["stephen@intercom.io"]
  spec.summary       = %q{Liberally parse CSV files}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
