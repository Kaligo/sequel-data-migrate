# frozen_string_literal: true

require "sequel"
require "sequel_data/migrate/migration"

module SequelData
  module Migrate
    class Migrator
      DATE_TIME_PATTERN = "[0-9]" * 14 # YYYYMMDDHHMMSS
      FILE_NAME_PATTERN = "#{DATE_TIME_PATTERN}_*.rb"
      MUTEX = Mutex.new

      def initialize(config)
        @config = config
      end

      def migrate
        db = connect_database
        dataset = ensure_table_exists(db)

        already_migrated = dataset.select_map(column).to_set
        migration_files = fetch_migration_files.reject { |file| already_migrated.include?(File.basename(file)) }.sort
        migrations = fetch_migrations(migration_files)

        migrations.zip(migration_files).each do |migration, file|
          db.log_info("Begin applying migration file #{file}")
          migration.new.up
          set_migration_version(db, file)
          db.log_info("Finished applying migration version #{file}")
        end
      end

      def rollback(step = 1)
        db = connect_database
        dataset = ensure_table_exists(db)

        already_migrated = dataset.select_map(column).to_set
        migration_files = fetch_migration_files.select do |file|
          already_migrated.include?(File.basename(file))
        end.sort.reverse!
        migrations = fetch_migrations(migration_files)

        migrations.zip(migration_files).each do |migration, file|
          step -= 1
          break if step.negative?

          db.log_info("Begin rolling back migration file #{file}")
          migration.new.down
          remove_migration_version(db, file)
          db.log_info("Finished rolling back migration version #{file}")
        end
      end

      private

      attr_reader :config

      def column
        :version
      end

      def table
        :data_migrations
      end

      def connect_database
        raise ConfigurationError, "db_configuration is not set" if config.db_configuration.host.nil?

        Sequel.connect(config.db_configuration.host)
      end

      def ensure_table_exists(db)
        # we need to set this so that it can be used within create_table? block
        c = column

        db.from(table).tap do |dataset|
          db.create_table?(table) do
            String c, null: false, primary: true
          end

          unless dataset.columns.include?(c)
            db.alter_table(table) do
              add_column c, String, null: false, primary: true
            end
          end
        end
      end

      def fetch_migration_files
        Dir.glob("#{config.migration_path}/#{FILE_NAME_PATTERN}")
      end

      # Load the migration file, raising an exception if the file does not define
      # a single migration.
      def load_migration_file(file)
        MUTEX.synchronize do
          length = Migration.descendants.length

          load(file)

          if length != Migration.descendants.length - 1
            raise MigrationError, "Migration file #{file.inspect} not containing a single migration detected"
          end

          klass = Migration.descendants.pop
          if klass.is_a?(Class) && !klass.name.to_s.empty? && Object.const_defined?(klass.name)
            Object.send(:remove_const, klass.name)
          end

          klass
        end
      end

      # Returns a list of migration classes filtered for the migration range and
      # ordered according to the migration direction.
      def fetch_migrations(migration_files)
        migration_files.map { |file| load_migration_file(file) }
      end

      def set_migration_version(db, file)
        db.from(table).insert(column => File.basename(file))
      end

      def remove_migration_version(db, file)
        db.from(table).where(column => File.basename(file)).delete
      end
    end
  end
end
