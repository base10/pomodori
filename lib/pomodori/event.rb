# TODO: Each event will have to declare a type
# TODO: Acceptable states will be defined. 
# In both cases above, this is to work around sqlite's lack of enum fields

# kinds:    'pomodoro', 'break', 'long_break'
# States:   'complete', 'aborted', 'in_progress'

module Pomodori
  class Event
    include Pomodori::Config

    attr_accessor :notifications, :summary, :duration, 
                  :started_at, :completed_at

    def kind
      
    end

    def state
      
    end
  end
end
