#-*- mode: ruby; x-counterpart: ../../spec/lib/configuration_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

require 'yaml'

module Pomodori
  class Configuration
    attr_accessor :config, :needs_setup, :environment

    def initialize( config_file = nil )
      read_config config_file
      set_environment
    end

    def default_config_path
      config_path = ENV['HOME'] + "/.pomodori"
      config_path
    end

    # FIXME: This method should be temporary
    def config_path
      default_config_path
    end

    def database_file
      file_name = config['database'].fetch( environment )
      "#{config_path}/#{file_name}"
    end

    def default_config_file
      file_path = default_config_path + "/pomodori.yml"
      file_path
    end

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

    def known_environments
      ['production', 'test', 'development']
    end

    def set_environment
      env = ENV.fetch('POMODORI_ENV') { 'production' }

      check_environment_validity( env )
      @environment = env
    end

    def check_environment_validity( environment )
      unless known_environments.member?( environment )
        raise StandardError, "Improper environment. Must be in #{known_environments.flatten}"
      end
    end

    def get_duration( event_type )
      type_info = config.fetch( event_type )
      duration  = type_info.fetch('duration')
    end

    def get_summary( event_type )
      type_info = config.fetch( event_type )
      summary   = type_info.fetch('summary')
    end
  end
end
