# frozen_string_literal: true

require 'dry-configurable'
require_relative "migrate/version"

module SequelData
  module Migrate
    extend Dry::Configurable

    setting :db_configuration
    setting :migration_path, default: "db/data"

    class Error < StandardError; end
  end
end
