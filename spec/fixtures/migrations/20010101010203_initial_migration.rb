# frozen_string_literal: true

class InitialMigration < SequelData::Migrate::Migration
  def up
    DB.execute("UPDATE data SET name = 'bar'")
  end

  def down
    DB.execute("UPDATE data SET name = 'foo'")
  end
end
