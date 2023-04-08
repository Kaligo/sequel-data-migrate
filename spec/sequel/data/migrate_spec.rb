# frozen_string_literal: true

RSpec.describe Sequel::Data::Migrate do
  it "has a version number" do
    expect(Sequel::Data::Migrate::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
