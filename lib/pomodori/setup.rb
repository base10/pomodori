#-*- mode: ruby; x-counterpart: ../../spec/lib/setup_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

require 'fileutils'

module Pomodori
  # This class is used to instantiate Pomodori by creating a config file
  # and database.
  class Setup
    attr_reader :initial_config_file, :database, :configuration

    # Builds a new Pomodori::Setup object
    # @param file_path [String]
    # @return [Object] A Pomodori::Setup object. Then, use the #run method
    def initialize( file_path = nil )
      @initial_config_file  = file_path || File.expand_path( "../../../config/pomodori.yml", __FILE__)
      @configuration        = Pomodori::Configuration.new

      @configuration.read_config initial_config_file
      @configuration.set_environment

      @database = Pomodori::Database.new( { configuration: configuration } )
    end

    # Run the setup process
    # - Setting up a config file
    # - Creating a database
    # - Bootstrapping the database schema
    def run
      ensure_config_path_exists
      ensure_config_file_exists
      ensure_database_exists
      setup_database_schema
    end

    # Make sure there's a spot to write the config file and database file to
    def ensure_config_path_exists
      unless File.directory? configuration.default_config_path
        FileUtils.mkdir_p configuration.default_config_path
      end
    end

    # Put a config file into place if there isn't one
    def ensure_config_file_exists
      unless File.exists? configuration.default_config_file
        FileUtils.cp initial_config_file, configuration.default_config_file
      end
    end

    # Create a database if necessary
    def ensure_database_exists
      database.ensure_database_exists
    end

    # Make sure database is current against data migrations
    def setup_database_schema
      database.run_migrations
    end
  end
end
