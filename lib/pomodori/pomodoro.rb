module Pomodori
  class Pomodoro < Pomodori::Event
    def initialize( values = {} )
      @config = CONFIG

      values[:kind]       = 'pomodoro'
      values[:duration]   = @config[values[:kind]]['duration']
      values[:summary]    = @config[values[:kind]]['summary']

      super(values)
    end
  end
end
