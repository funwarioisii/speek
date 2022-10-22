# frozen_string_literal: true

require "thor"
require "speek/application"

module Speek
  # Command Line Interface
  class CLI < Thor
    default_command :parse

    desc "parse [option] <path, ...>", "generate expected schema type"
    option :schema_type, type: :string, aliases: "-s", desc: "schema type like rbs graphql protobuf"
    option :output_file_path, type: :string, aliases: "-o", desc: "output file path"
    option :input_file_path, type: :string, aliases: "-i", desc: "input file path"

    def parse
      schema_type = options[:schema_type]
      output_file_path = options[:output_file_path]
      input_file_path = options[:input_file_path]

      if schema_type.nil? && input_file_path.nil?
        puts "must set schema type and input file path"
        exit 1
      end

      unless File.file?(input_file_path)
        puts "should pass valid file path. `#{input_file_path}` dose not exist."
        exit 1
      end

      app = Speek::Application.read(input_file_path)

      exporter = case schema_type&.to_sym
                 when :rbs
                   Export::Rbs
                 when :gql, :graphql
                   Export::Graphql
                 else
                   raise "no support pattern"
                 end
      code = exporter.new(app).export

      if output_file_path.present?
        File.new(output_file_path).write(code)
      else
        puts code
      end
    end
  end
end
