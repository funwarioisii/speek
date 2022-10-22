# frozen_string_literal: true

require "rspec"
require "speek/export/rbs"

RSpec.describe Speek::Export::Rbs do
  describe "#export" do
    let(:code) do
      <<~RUBY
        create_table "users", id: :bigint do |t|
          t.string "name", null: false
          t.text "desc", null: true
          t.datetime "deleted_at"
          t.integer "weight", null: false, default: 0, unsigned: true
          t.boolean "is_banned", null: false, default: false

          t.timestamps
        end
      RUBY
    end

    it do
      rbs = <<~RUBY
        class User
          attr_accessor id: Integer
          attr_accessor name: String
          attr_accessor desc: (String | nil)
          attr_accessor deleted_at: (Time | nil)
          attr_accessor weight: Integer
          attr_accessor is_banned: Boolean
          attr_accessor created_at: Time
          attr_accessor updated_at: Time
        end
      RUBY
      app = Speek::Application.new(code)
      expect(described_class.new(app).export).to eq rbs
    end
  end
end
