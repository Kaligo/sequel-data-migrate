# frozen_string_literal: true

require_relative "lib/sequel_data/migrate/version"

Gem::Specification.new do |spec|
  spec.name = "sequel-data-migrate"
  spec.version = SequelData::Migrate::VERSION
  spec.authors = ["Hieu Nguyen"]
  spec.email = ["hieuk09@gmail.com"]

  spec.summary = "Migrate data with Sequel"
  spec.description = "Migrate data with Sequel"
  spec.homepage = "https://github.com/hieuk09/sequel-data-migrate"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/hieuk09/sequel-data-migrate/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|github))})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sequel", ">= 4.0.0"
  spec.add_dependency "dry-configurable", ">= 0.13.0"
end
