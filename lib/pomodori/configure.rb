require 'yaml'
require 'pp'

module Pomodori
  module Configure
    attr_accessor :config, :needs_setup, :environment

    def initialize( config_file = nil )
      read_config config_file
      set_environment
    end

    # FIXME: Make this a constant instead?
    def default_config_path
      config_path = ENV['HOME'] + "/.pomodori"
      config_path
    end

    # FIXME: Make this a constant instead?
    def default_config_file
      file_path = default_config_path + "/pomodori.yml"
      file_path
    end

    def read_config(file_path = nil)
      config_file = file_path || default_config_file

      if File.exists?( config_file )
        @config = YAML.load( File.read( config_file ) )
      else
        @needs_setup  = true
        db_path       = File.expand_path('../../tmp/tmp_db.sqlite3', __FILE__)

        @config = {
                    'database' => {
                      'production'  => db_path,
                      'test'        => db_path,
                      'development' => db_path
                    }
                  }

        # TODO: Determine context (am I testing?) and specify a more specific
        # error message
      end
    end

    def known_environments
      ['production', 'test', 'development']
    end

    def set_environment
      env = String.new

      if ENV['POMODORI_ENV']
        if known_environments.member?(ENV['POMODORI_ENV'])
          env = ENV['POMODORI_ENV']
        else
          raise Exception, "Improper environment. Must be in #{known_environments.flatten}"
        end
      else
        env = 'production'
      end

      @environment = env
    end
  end
end
