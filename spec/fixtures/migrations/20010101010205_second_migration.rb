# frozen_string_literal: true

class SecondMigration < SequelData::Migrate::Migration
  def up
    DB.execute("UPDATE data SET name = 'foobar'")
  end

  def down
    DB.execute("UPDATE data SET name = 'bar'")
  end
end
