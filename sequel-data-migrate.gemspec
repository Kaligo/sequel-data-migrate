# frozen_string_literal: true

require_relative "lib/sequel_data/migrate/version"

Gem::Specification.new do |spec|
  spec.name = "sequel-data-migrate"
  spec.version = SequelData::Migrate::VERSION
  spec.authors = ["Hieu Nguyen"]
  spec.email = ["hieu.nguyen@ascendaloyalty.com"]

  spec.summary = "Migrate data with Sequel"
  spec.description = "Migrate data with Sequel, based on Sequel migration extension"
  spec.homepage = "https://github.com/kaligo/sequel-data-migrate"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/kaligo/sequel-data-migrate/blob/master/CHANGELOG.md"

  spec.files = Dir.glob("{lib,sig}/**/*") + %w[README.md CHANGELOG.md LICENSE.txt]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-configurable", ">= 0.10.0"
  spec.add_dependency "sequel", ">= 4.0.0"
  spec.metadata["rubygems_mfa_required"] = "true"
end
