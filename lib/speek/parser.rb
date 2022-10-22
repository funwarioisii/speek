# frozen_string_literal: true

module Speek
  # ridgepole schema を Speek で扱いやすいようにする
  module Parser
    def table_name
      @ast.children.last.children.first.children[1].children.first.children.first
    end

    def id_type
      @ast.children.last.children.first.children[1].children[1].children.first.children[1].children.first
    end

    def columns
      create_table_inner_node = @ast.children.last.children[1].children.last
      case create_table_inner_node.type
      when :CALL
        [
          @ast.children.last.children[1].children.last
              .then { |column_ast_node| extract_column(column_ast_node) }
        ]
          .unshift(ColumnData.new(name: "id", type: id_type, nullable: false, option: {}))
          .flatten
      when :BLOCK
        @ast.children.last.children[1].children.last.children
            .map { |column_ast_node| extract_column(column_ast_node) }
            .unshift(ColumnData.new(name: "id", type: id_type, nullable: false, option: {}))
            .flatten
      end
    end

    private

    def extract_column(column_ast_node)
      column_type = column_ast_node.children[1]
      if column_type == :timestamps
        return [
          ColumnData.new(
            name: "created_at",
            type: :datetime,
            nullable: false
          ),
          ColumnData.new(
            name: "updated_at",
            type: :datetime,
            nullable: false
          )
        ]
      end

      column_name_node, option_ast_node = column_ast_node.children[2].children.compact
      column_name = column_name_node.children.first
      option = {}
      column_data = ColumnData.new(
        name: column_name,
        type: column_type,
        nullable: true,
        option:
      )

      return column_data if option_ast_node.nil?

      option_ast_node.children.compact.first.children.compact.each_slice(2).map do |key_node, value_node|
        key = key_node.children.first
        value = case value_node.type
                when :TRUE
                  true
                when :FALSE
                  false
                when :LIT
                  value_node.children.first
                else
                  raise
                end
        if key == :null
          column_data.nullable = value
          next
        end

        column_data.option[key] = value
      end

      column_data
    end
  end
end
