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

      def self.apply(db, direction)
        raise MigrationError, "Invalid direction #{direction.inspect}" unless VALID_DIRECTION.include?(direction)

        new(db).public_send(direction)
      end

      def initialize(db)
        @db = db
      end

      def up
        raise MigrationError, "No up method defined for migration #{self.class}"
      end

      def down
        raise MigrationError, "No down method defined for migration #{self.class}"
      end

      private

      attr_reader :db
    end
  end
end
