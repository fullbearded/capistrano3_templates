# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano3_templates/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano3_templates"
  spec.version       = Capistrano3Templates::VERSION
  spec.authors       = ["Hongda Hu"]
  spec.email         = ["hdhu@thoughtworks.com"]
  spec.summary       = %q{provide a capistrano 3 basic configuares}
  spec.description   = %q{this is the templates gem for capistrano 3, you can use it for your project to deployment}
  spec.homepage      = "https://github.com/huhongda/capistrano3_templates"

  spec.extra_rdoc_files = ["README.md"]
  spec.rdoc_options     = ["--charset=UTF-8"]

  #s.files            = `git ls-files -z`.split("\x0")
  spec.files = Dir.glob("{lib}/**/*") + %w(README.md)

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rdoc"
  spec.add_development_dependency "whenever"
  # spec.add_development_dependency "pry"

end
