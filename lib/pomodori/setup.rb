#-*- mode: ruby; x-counterpart: ../../spec/lib/setup_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

require 'fileutils'

module Pomodori
  class Setup
    attr_reader :initial_config_file, :database, :configuration

    def initialize( file_path = nil )
      @initial_config_file  = file_path || File.expand_path( "../../../config/pomodori.yml", __FILE__)
      @configuration        = Pomodori::Configuration.new

      @configuration.read_config initial_config_file
      @configuration.set_environment

      @database = Pomodori::Database.new( { configuration: configuration } )
    end

    def run
      ensure_config_path_exists
      ensure_config_file_exists
      ensure_database_exists
      setup_database_schema
    end

    def ensure_config_path_exists
      unless File.directory? configuration.default_config_path
        FileUtils.mkdir_p configuration.default_config_path
      end
    end

    def ensure_config_file_exists
      unless File.exists? configuration.default_config_file
        FileUtils.cp initial_config_file, configuration.default_config_file
      end
    end

    # FIXME: Likely component of DCI
    def ensure_database_exists
      database.ensure_database_exists
    end

    # FIXME: Likely component of DCI
    def setup_database_schema
      database.run_migrations
    end
  end
end
