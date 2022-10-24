# frozen_string_literal: true

require "rspec"
require "speek/export/rbs"

RSpec.describe Speek::Export::Graphql do
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

  describe "#export" do
    it do
      gql = <<~GRAPHQL
        type User {
          id: Int!
          name: String!
          desc: String
          deletedAt: String
          weight: Int!
          isBanned: Boolean!
          createdAt: String!
          updatedAt: String!
        }
      GRAPHQL
      app = Speek::Application.new(code)
      expect(described_class.new(app).export).to eq gql
    end
  end
end
