# frozen_string_literal: true

require "logger"
require "speek/version"

module Speek
  def self.logger
    @logger ||=
      begin
        $stdout.sync = true
        Logger.new($stdout).tap do |l|
          l.level = Logger::INFO
        end
      end
  end
end
