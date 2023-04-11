# frozen_string_literal: true

RSpec.describe SequelData::Migrate::Generator do
  describe "#create_migration" do
    let(:migration_path) { 'spec/output' }
    let(:file_pattern) { "#{migration_path}/*.rb" }
    let(:config) { double('Config', migration_path: migration_path) }

    after do
      Dir[file_pattern].each { |file| File.delete(file) }
    end

    it "creates migration file" do
      path = nil

      expect do
        path = described_class.new(config).create_migration("backfill_users_email")
      end.to change { Dir[file_pattern].size }.by(1)

      expect(File.read(path)).to include("class BackfillUsersEmail < SequelData::Migrate::Migration")
    end
  end
end
