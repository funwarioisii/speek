# frozen_string_literal: true

require "speek/export/base"
require "speek/application"

module Speek
  module Export
    # for generate RBS code
    class Rbs < Base
      def export
        <<~RUBY
          class #{class_name}
            #{@app.schema_data.columns.map { |column| generate_attr_accessor(column) }.join("\n  ")}
          end
        RUBY
      end

      private

      def class_name = @app.schema_data.table_name.singularize.camelize

      def generate_attr_accessor(column_data)
        type = convert_type(column_data.type)
        type = "(#{type} | nil)" if column_data.nullable

        "attr_accessor #{column_data.name}: #{type}"
      end

      def convert_type(type)
        case type
        when :integer, :bigint
          "Integer"
        when :string, :text
          "String"
        when :datetime
          "Time"
        when :boolean
          "Boolean"
        else
          raise UnknownColumnTypeError, "Unknown column type: #{type}"
        end
      end
    end
  end
end
