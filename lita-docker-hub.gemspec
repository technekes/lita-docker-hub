require File.expand_path("../lib/lita/handlers/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "lita-docker-hub"
  spec.version       = DockerHub::VERSION
  spec.authors       = ["Martin Fenner"]
  spec.email         = ["mfenner@datacite.org"]
  spec.description   = "A Docker Hub plugin for Lita."
  spec.summary       = "Lita extension to consume Docker Hub webhook events."
  spec.homepage      = "https://github.com/datacite/lita-docker-hub"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.7"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
