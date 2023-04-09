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
    end
  end
end
