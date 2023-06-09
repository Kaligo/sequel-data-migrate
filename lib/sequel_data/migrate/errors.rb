# frozen_string_literal: true

module SequelData
  module Migrate
    class Error < StandardError; end

    class ConfigurationError < Error; end

    class MigrationError < Error; end
  end
end
