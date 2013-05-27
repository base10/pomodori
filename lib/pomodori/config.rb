require 'yaml'
require 'fileutils'

module Pomodori
  module Config
    attr_reader :config

    def default_config_file
      file_path = ENV['HOME'] + "/.pomodori/pomodori.yml"
      file_path
    end

    def read_config(file_path = nil)
      config_file = file_path || default_config_file

      if !File.exists?( config_file )
        raise Errno::ENOENT, "#{config_file}"
      end

      # TODO: Consider wrapping this in a begin/rescue block to 
      # specify a more specific error message
      config_data = YAML.load( File.read( config_file ) )

      @config = config_data
    end
  end
end
