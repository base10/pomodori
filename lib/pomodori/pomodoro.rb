module Pomodori
  class Pomodoro < Pomodori::Event
    def initialize( values = {} )
      @config = CONFIG

      values[:kind]       = determine_kind
      values[:duration]   = @config[values[:kind]]['duration']
      values[:summary]    = @config[values[:kind]]['summary']

      super(values)
    end

    def determine_kind
      klass       = self.class.to_s.downcase
      hierarchy   = klass.split(/\:\:/)
      kind        = hierarchy.pop
    end
  end
end
