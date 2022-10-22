# frozen_string_literal: true

require_relative "../lib/speek"

puts Speek.read("example/schema/users.schema").to_rbs
