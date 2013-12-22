#-*- mode: ruby; x-counterpart: ../../spec/lib/configuration_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

require 'yaml'

module Pomodori

  # Class to handle configuration (go figure!).
  class Configuration
    attr_accessor :config, :needs_setup, :environment

    # Builds a new Pomodori::Configuration object
    # @param config_file [String] (Optional) Path to a YAML-based configuration file.
    #   A default file is provided if config_file is not specified
    # @return [Object] A Pomodori::Configuration object is returned
    def initialize( config_file = nil )
      read_config config_file
      set_environment
    end

    # @return [String] Path of where the application config file and database are by default
    def default_config_path
      config_path = ENV['HOME'] + "/.pomodori"
      config_path
    end

    # @return [String] Path where application config file and database are located
    # FIXME: This method should be temporary
    def config_path
      default_config_path
    end

    # @return [String] The SQLite file to use as the application data store
    #   NB: This varies by environment
    def database_file
      file_name = config['database'].fetch( environment )
      "#{config_path}/#{file_name}"
    end

    # @return [String] Path to the default configuration file
    def default_config_file
      file_path = default_config_path + "/pomodori.yml"
      file_path
    end

    # Read a YAML-formatted config file
    # @param file_path [String] (optional) Path pointing to the YAML config file to use
    def read_config( file_path = nil )
      config_file = file_path || default_config_file
      @config     = YAML.load( File.read( config_file ) )
    rescue Errno::ENOENT
      @needs_setup  = true
      db_path       = File.expand_path('../../tmp/tmp_db.sqlite3', __FILE__)

      @config = {
                  'database' => {
                    'production'  => db_path,
                    'test'        => db_path,
                    'development' => db_path
                  }
                }
    end

    # @return [Array] of the known good environments
    def known_environments
      ['production', 'test', 'development']
    end

    # Sets the environment based on the POMODORI_ENV environment variable.
    # See #known_environments for known good environments
    def set_environment
      env = ENV.fetch('POMODORI_ENV') { 'production' }

      check_environment_validity( env )
      @environment = env
    end

    # @param event_type [String]
    # @return [Fixnum] the default duration for the event type
    def get_duration( event_type )
      type_info = config.fetch( event_type )
      duration  = type_info.fetch('duration')
    end

    # @param event_type [String]
    # @return [String] the default summary for the event type
    def get_summary( event_type )
      type_info = config.fetch( event_type )
      summary   = type_info.fetch('summary')
    end

    protected

    def check_environment_validity( environment )
      unless known_environments.member?( environment )
        raise StandardError, "Improper environment. Must be in #{known_environments.flatten}"
      end
    end
  end
end
