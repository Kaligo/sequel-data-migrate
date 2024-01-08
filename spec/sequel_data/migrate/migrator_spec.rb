# frozen_string_literal: true

RSpec::Matchers.define_negated_matcher :not_change, :change

RSpec.describe SequelData::Migrate::Migrator do
  let(:db) { DB }
  let(:config) do
    double(
      "Config",
      db_configuration: double("Config", host: HOST),
      migration_path: "spec/fixtures/migrations"
    )
  end
  let(:migrator) { described_class.new(config) }

  # rubocop:disable RSpec/BeforeAfterAll
  before(:all) do
    # We need to use DB instead of db because inside before(:all)
    # block db is not defined yet
    DB.create_table(:data) do
      primary_key :id
      String :name, null: false
    end
  end

  after(:all) do
    DB.drop_table(:data)
  end
  # rubocop:enable RSpec/BeforeAfterAll

  describe "#migrate" do
    let(:versions) do
      [
        "20010101010203_initial_migration.rb",
        "20010101010205_second_migration.rb"
      ]
    end

    before do
      db[:data].insert(name: "foo")
    end

    after do
      db[:data].truncate
    end

    context "when db configuration is not set" do
      let(:config) do
        double(
          "Config",
          db_configuration: double("Config", host: nil),
          migration_path: "spec/fixtures/migrations"
        )
      end

      it "raises error" do
        expect do
          migrator.migrate
        end.to raise_error(SequelData::Migrate::ConfigurationError, "db_configuration is not set")
      end
    end

    context "when table does not exist" do
      after { db.drop_table(:data_migrations) }

      it "creates table and migrates database" do
        expect do
          migrator.migrate
        end.to change {
          db[:data].select_map(:name)
        }.from(["foo"]).to(["foobar"]).and change {
          db.table_exists?(:data_migrations)
        }.from(false).to(true)

        expect(db[:data_migrations].order(:version).select_map(:version)).to eq(versions)
      end
    end

    context "when table exists" do
      before do
        db.create_table(:data_migrations) do
          String :version, null: false, primary: true
        end
      end

      after { db.drop_table(:data_migrations) }

      it "migrates database" do
        expect do
          migrator.migrate
        end.to change {
          db[:data].select_map(:name)
        }.from(["foo"]).to(["foobar"]).and change {
          db[:data_migrations].order(:version).select_map(:version)
        }.from([]).to(versions)
      end
    end

    context "when data is migrated already" do
      before do
        db.create_table(:data_migrations) do
          String :version, null: false, primary: true
        end

        db[:data_migrations].insert(version: "20010101010205_second_migration.rb")
      end

      after { db.drop_table(:data_migrations) }

      it "does not migrate database" do
        expect do
          migrator.migrate
        end.to change {
          db[:data].select_map(:name)
        }.from(["foo"]).to(["bar"]).and change {
          db[:data_migrations].order(:version).select_map(:version)
        }.from(["20010101010205_second_migration.rb"]).to(versions)
      end
    end

    context "when migrations are applied" do
      it "does not leave extra connections open" do
        expect do
          migrator.migrate
        end.to(not_change do
          Sequel::DATABASES.size
        end)
      end
    end
  end

  describe "#rollback" do
    before do
      db[:data].insert(name: "foo")
    end

    after do
      db[:data].truncate
    end

    context "when db configuration is not set" do
      let(:config) do
        double(
          "Config",
          db_configuration: double("Config", host: nil),
          migration_path: "spec/fixtures/migrations"
        )
      end

      it "raises error" do
        expect do
          migrator.rollback
        end.to raise_error(SequelData::Migrate::ConfigurationError, "db_configuration is not set")
      end
    end

    context "when table does not exist and nothing is migrated" do
      after { db.drop_table(:data_migrations) }

      it "creates table and rollback database" do
        expect do
          migrator.rollback
        end.to change {
          db.table_exists?(:data_migrations)
        }.from(false).to(true)

        expect(db[:data_migrations].select_map(:version)).to eq([])
        expect(db[:data].select_map(:name)).to eq(["foo"])
      end
    end

    context "when table exists and we rollback one step" do
      before { migrator.migrate }

      after { db.drop_table(:data_migrations) }

      it "rollback database one step" do
        expect do
          migrator.rollback
        end.to change {
          db[:data].select_map(:name)
        }.from(["foobar"]).to(["bar"]).and change {
          db[:data_migrations].order(:version).select_map(:version)
        }.from(["20010101010203_initial_migration.rb",
                "20010101010205_second_migration.rb"]).to(["20010101010203_initial_migration.rb"])
      end
    end

    context "when table exists and we rollback all steps" do
      before { migrator.migrate }

      after { db.drop_table(:data_migrations) }

      it "rollback database" do
        expect do
          migrator.rollback(2)
        end.to change {
          db[:data].select_map(:name)
        }.from(["foobar"]).to(["foo"]).and change {
          db[:data_migrations].order(:version).select_map(:version)
        }.from(["20010101010203_initial_migration.rb", "20010101010205_second_migration.rb"]).to([])
      end
    end

    context "when rollbacks are applied" do
      before { migrator.migrate }

      after { db.drop_table(:data_migrations) }

      it "does not leave extra connections open" do
        expect do
          migrator.rollback
        end.to(not_change do
          Sequel::DATABASES.size
        end)
      end
    end
  end
end
