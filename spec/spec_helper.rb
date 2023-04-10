# frozen_string_literal: true

# enable rbs type checking
if RUBY_VERSION >= "3"
  ENV["RBS_TEST_TARGET"] ||= "SequelData::*"
  require "rbs/test/setup"
end

require "sequel_data/migrate"

HOST = "sqlite://spec/db/test.sqlite3"
DB = Sequel.connect(HOST)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
