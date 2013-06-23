# TODO: Each event will have to declare a type
# TODO: Acceptable states will be defined. 
# In both cases above, this is to work around sqlite's lack of enum fields

# kinds:    'pomodoro', 'break', 'long_break'
# States:   'complete', 'aborted', 'in_progress'

# @@database = Pomodori::Database.new
# @@database.connect
# 

require 'pp'

module Pomodori
  database  = Pomodori::Database.new
  DB        = database.connect

  CONFIG    = database.config

  class Event < Sequel::Model(:events)
    include Pomodori::Config

#     attr_accessor :notifications, :summary, :duration, 
#                   :started_at, :completed_at, :database

    def after_initialize
      super
      @config = CONFIG
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
