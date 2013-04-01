$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails-gallery/version"

Gem::Specification.new do |spec|
  spec.name          = "rails-gallery"
  spec.version       = RailsGallery::VERSION
  spec.authors       = ["Kristian Mandrup"]
  spec.date          = "2012-10-11"
  spec.summary       = "Gallery functionality for Rails apps"
  spec.description   = "Add photo galleries to your Rails apps :)"
  spec.email         = "kmandrup@gmail.com"
  spec.homepage      = "https://github.com/kristianmandrup/rails-gallery"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails',         '>= 3.1'
  spec.add_dependency 'hashie',        '>= 2.0.0'
end
