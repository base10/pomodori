require 'fileutils'

module Pomodori
  class Setup
    include Pomodori::Configure

    attr_reader :initial_config_file
    attr_reader :database

    # FIXME: Call Pomodori::Config#initialize
    def initialize( file_path = nil )
      @initial_config_file = file_path || File.expand_path( "../../../config/pomodori.yml", __FILE__)

      read_config initial_config_file
      set_environment

      @database = Pomodori::Database.new( @initial_config_file )
    end

    def run
      ensure_config_path_exists
      ensure_config_file_exists
      ensure_database_exists
      setup_database_schema
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
