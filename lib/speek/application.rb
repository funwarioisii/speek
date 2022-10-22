# frozen_string_literal: true

require "speek/export/rbs"
require "speek/export/graphql"
require "speek/parser"

ColumnData = Struct.new(:name, :type, :nullable, :option, keyword_init: true)
SchemaData = Struct.new(:table_name, :id_type, :columns, keyword_init: true)

module Speek
  # parse code and generate schema by included modules
  class Application
    include Speek::Export
    include Speek::Parser

    attr_reader :ast

    def initialize(code)
      @ast = RubyVM::AbstractSyntaxTree.parse(code)
    end

    def self.read(filename)
      code = File.read(filename)
      new(code)
    end

    def schema_data
      @schema_data ||= SchemaData.new(table_name:, id_type:, columns:)
    end
  end
end
