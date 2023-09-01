# frozen_string_literal: true

require "dry-configurable"
require "dry/configurable/version"
require "sequel_data/migrate/version"
require "sequel_data/migrate/errors"
require "sequel_data/migrate/migrator"
require "sequel_data/migrate/generator"

module SequelData
  module Migrate
    extend Dry::Configurable

    setting :db_configuration do
      setting :host
    end

    if Dry::Configurable::VERSION >= "0.13.0"
      setting :migration_path, default: "db/data"
    else
      setting :migration_path, "db/data"
    end

    def self.migrate
      Migrator.new(config).migrate
    end

    def self.rollback(step = 1)
      Migrator.new(config).rollback(step)
    end

    def self.create_migration(name)
      Generator.new(config).create_migration(name)
    end
  end
end
