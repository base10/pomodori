require 'yaml'
require 'fileutils'

module Pomodori
  class Config
    attr_reader :config

    def initialize(file_path = nil)
      config_file = file_path || ENV['HOME'] + "/.pomodori/pomodori.yml"

      if !File.exists?( config_file )
        raise Errno::ENOENT, "#{config_file}"
      end

      config = YAML.load( File.read( config_file ) )
      
      @config = config
    end
  end
end
