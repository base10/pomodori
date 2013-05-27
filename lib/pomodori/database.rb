module Pomodori
  class Database
    include Pomodori::Config

  	def initialize( config_file = nil )
      read_config
  	end
  end
end
