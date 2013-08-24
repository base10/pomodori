module Pomodori
  class Pomodoro < Pomodori::Event
    def initialize( values = {} )
      values[:kind]       = 'pomodoro'
      values[:duration]   = 25

      # TODO, define strategy for pulling duration, default summary
      super(values)
    end
  end
end
