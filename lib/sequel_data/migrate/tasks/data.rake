# frozen_string_literal: true

require "sequel_data/migrate"

namespace :data do
  desc "Run data migrations"
  task :migrate do
    SequelData::Migrate.migrate
  end

  desc "Rollback data migrations"
  task :rollback, %i[step] do |_, args|
    SequelData::Migrate.rollback(args.fetch(:step, 1).to_i)
  end

  desc "Create a migration (parameters: NAME)"
  task :create_migration, %i[name] do |_, args|
    name = args[:name]

    if name.nil?
      puts "No NAME specified. Example usage:
        `rake db:create_migration[backfill_users_email]`"
      exit
    end

    path = SequelData::Migrate.create_migration(name)

    puts "<= migration file created #{path}"
  end
end
