# frozen_string_literal: true

require 'dry-configurable'
require 'sequel_data/migrate/version'
require 'sequel_data/migrate/errors'
require 'sequel_data/migrate/migrator'

module SequelData
  module Migrate
    extend Dry::Configurable

    setting :db_configuration do
      setting :host
    end
    setting :migration_path, default: "db/data"

    def self.forward
      Migrator.new(config).forward
    end
  end
end
