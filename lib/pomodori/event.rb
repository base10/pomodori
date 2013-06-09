# TODO: Each event will have to declare a type
# TODO: Acceptable states will be defined. 
# In both cases above, this is to work around sqlite's lack of enum fields

# kinds:    'pomodoro', 'break', 'long_break'
# States:   'complete', 'aborted', 'in_progress'

# @@database = Pomodori::Database.new
# @@database.connect
# 

#@@database = Pomodori::Database.new

module Pomodori
#   DB = @@database.connect

  class Event #< Sequel::Model
    attr_accessor :notifications, :summary, :duration, 
                  :started_at, :completed_at, :database

    def initialize(*opts)
      #@config = @@database.config

      #super opts
    end

    def kind
      
    end

    def kind=( thing )
    
    end

    def state
      
    end

    def validate

    end

    # begin
    # mark_complete
    # mark_incomplete
  end
end
