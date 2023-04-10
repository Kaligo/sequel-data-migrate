# frozen_string_literal: true

RSpec.describe SequelData::Migrate::Migration do
  let(:migration) { described_class.new }

  describe "#up" do
    it "raises an error" do
      expect { migration.up }.to raise_error(SequelData::Migrate::MigrationError, /No up method defined/)
    end
  end

  describe "#down" do
    it "raises an error" do
      expect { migration.down }.to raise_error(SequelData::Migrate::MigrationError, /No down method defined/)
    end
  end
end
