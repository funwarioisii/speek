# frozen_string_literal: true

require "rspec"
require "speek/application"

RSpec.describe "Speek::Parser" do
  let(:app) { Speek::Application.new(code) }
  describe "#table_name" do
    let(:code) do
      <<~RUBY
        create_table "users", id: :bigint do|t|
        end
      RUBY
    end

    it { expect(app.table_name).to eq("users") }
  end

  describe "#columns" do
    context "single column" do
      let(:code) do
        <<~RUBY
          create_table "users", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB" do |t|
            t.string "name", null: false
          end
        RUBY
      end

      it "should include id column data" do
        expect(app.columns)
          .to include(ColumnData.new(name: "id", type: :bigint, nullable: false, option: {}))
      end
    end

    context "declare id" do
      let(:code) do
        <<~RUBY
          create_table "users", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB" do |t|
            t.string "name", null: false
            t.text "desc", null: true
          end
        RUBY
      end

      it "should include id column data" do
        expect(app.columns)
          .to include(ColumnData.new(name: "id", type: :bigint, nullable: false, option: {}))
      end
    end

    context "option null: false" do
      let(:code) do
        <<~RUBY
          create_table "users", id: :bigint do|t|
            t.string "name", null: false
            t.text "desc", null: true
          end
        RUBY
      end

      it {
        expect(app.columns)
          .to eq([
                   ColumnData.new(name: "id", type: :bigint, nullable: false, option: {}),
                   ColumnData.new(name: "name", type: :string, nullable: false, option: {}),
                   ColumnData.new(name: "desc", type: :text, nullable: true, option: {})
                 ])
      }
    end
  end
end
