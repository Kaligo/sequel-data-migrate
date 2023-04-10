# frozen_string_literal: true

module SequelData
  module Migrate
    class Migration
      VALID_DIRECTION = %i[up down].freeze

      # Returns the list of Migration descendants.
      def self.descendants
        @descendants ||= []
      end

      # Adds the new migration class to the list of Migration descendants.
      def self.inherited(base)
        descendants << base
        super
      end

      def up
        raise MigrationError, "No up method defined for migration #{self.class}"
      end

      def down
        raise MigrationError, "No down method defined for migration #{self.class}"
      end
    end
  end
end
