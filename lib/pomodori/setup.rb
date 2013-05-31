require_relative "config"
require 'fileutils'

module Pomodori
  class Setup
    include Pomodori::Config

    def default_config_path
      config_path = File.expand_path( "../../../config", __FILE__)
      config_path
    end

    def initialize
      read_config

      # TODO: Check to see if an alternate config exists and if it does, 
      # load it
    end

    def run
      ensure_config_path_exists

      # Install config if necessary
      # Find database state
        # Create the database
        # Run database migrations
    end

    def ensure_config_path_exists
      unless File.directory? default_config_path
        FileUtils.mkdir_p default_config_path
      end
    end
  end
end
