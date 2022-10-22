# frozen_string_literal: true

module Speek
  require "active_support/inflector"
  class UnknownColumnTypeError < StandardError; end

  module Export
    # Base class
    class Base
      attr_accessor :app

      def initialize(app)
        @app = app
      end

      def export; end
    end
  end
end
