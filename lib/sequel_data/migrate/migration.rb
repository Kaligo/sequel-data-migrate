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
      end

      def self.apply(db, direction)
        unless VALID_DIRECTION.include?(direction)
          raise MigrationError, "Invalid direction #{direction.inspect}"
        end

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
