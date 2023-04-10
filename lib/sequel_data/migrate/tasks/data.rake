# frozen_string_literal: true

require "sequel_data/migrate"

namespace :data do
  desc "Run data migrations"
  task :migrate do
    SequelData::Migrate.migrate
  end

  desc "Rollback data migrations"
  task :rollback do
    SequelData::Migrate.rollback
  end
end
