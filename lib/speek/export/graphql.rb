# frozen_string_literal: true

require "speek/export/base"
require "speek/application"
require "speek"

module Speek
  module Export
    # for generate GraphQL code
    class Graphql < Base
      def export
        <<~GRAPHQL
          type #{class_name} {
            #{@app.schema_data.columns.map { |column| generate_field(column) }.join("\n  ")}
          }
        GRAPHQL
      end

      private

      def class_name = @app.schema_data.table_name.singularize.camelize

      def generate_field(column_data)
        type = convert_type(column_data.type)
        type = "#{column_data.type}!" unless column_data.nullable
        "#{column_data.name.camelize(:lower)}: #{type}"
      end

      def convert_type(type)
        case type
        when :integer, :bigint
          "Int"
        when :string, :text, :datetime
          "String"
        when :boolean
          "Boolean"
        else
          raise UnknownColumnTypeError, "Unknown column type: #{type}"
        end
      end
    end
  end
end
