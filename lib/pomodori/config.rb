require 'yaml'

module Pomodori
  module Config
    attr_reader :config, :needs_setup

  	def initialize( config_file = nil )
      read_config config_file
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
        @needs_setup = true
        @config = {
                    'database' => {
                      'file' => File.expand_path('../../tmp/tmp_db.sqlite3', __FILE__) 
                    }
                  }
      end

      # TODO: Consider wrapping this in a begin/rescue block to 
      # specify a more specific error message
    end
  end
end
