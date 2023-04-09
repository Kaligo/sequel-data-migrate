require 'sequel_data/migrate'

namespace :data do
  desc 'Run data migrations'
  task :migrate do
    SequelData::Migrate.forward
  end
end
