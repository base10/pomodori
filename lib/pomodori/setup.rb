require_relative "config"
require_relative "database"

require 'fileutils'

module Pomodori
  class Setup
    include Pomodori::Config

    attr_reader :initial_config_file
    attr_reader :database

    def initialize( file_path = nil )
      @initial_config_file = file_path || File.expand_path( "../../../config/pomodori.yml", __FILE__)

      read_config @initial_config_file

      @database = Pomodori::Database.new( @initial_config_file )

      # TODO: Check to see if an alternate config exists and if it does, 
      # load it
    end

    def run
      ensure_config_path_exists
      ensure_config_file_exists
      ensure_database_exists
      # Find database state
        # Create the database
        # Run database migrations
    end

    def ensure_config_path_exists
      unless File.directory? default_config_path
        FileUtils.mkdir_p default_config_path
      end
    end

    def ensure_config_file_exists
      unless File.exists? default_config_file
        FileUtils.cp initial_config_file, default_config_file
      end
    end

    def ensure_database_exists
      database.ensure_database_exists
    end

    def setup_database_schema
    end
  end
end
