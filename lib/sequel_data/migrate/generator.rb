require 'fileutils'

module SequelData
  module Migrate
    class Generator
      VERSION_FORMAT = "%Y%m%d%H%M%S"

      def initialize(config)
        @config = config
      end

      def create_migration(name)
        version = Time.now.utc.strftime(VERSION_FORMAT)
        file_name = "#{version}_#{name}.rb"
        klass_name = name.split("_").map(&:capitalize).join
        content = <<~CONTENT
          class #{klass_name} < SequelData::Migrate::Migration
            def up
            end

            def down
            end
          end
        CONTENT

        File.join(config.migration_path, file_name).tap do |full_path|
          FileUtils.mkdir_p(config.migration_path)
          File.write(full_path, content)
        end
      end

      private

      attr_reader :config
    end
  end
end
