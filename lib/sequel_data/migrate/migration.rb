module SequelData
  module Migrate
    class Migration
      # Returns the list of Migration descendants.
      def self.descendants
        @descendants ||= []
      end

      # Adds the new migration class to the list of Migration descendants.
      def self.inherited(base)
        descendants << base
      end

      def self.apply(db)
        new(db).up
      end

      def initialize(db)
        @db = db
      end

      def up
        raise MigrationError, "No up method defined for migration #{self.class}"
      end

      private

      attr_reader :db
    end
  end
end
