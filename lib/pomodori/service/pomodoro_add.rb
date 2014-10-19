#-*- mode: ruby; x-counterpart: ../../../spec/lib/service/pomodoro_add_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-
module Pomodori::Service
  class PomodoroAdd
    attr_accessor :pomodori

    def initialize( options = {} )
      if options.has_key?('duration')
        options['length'] = options.fetch('duration')
      end

      @pomodori = Pomodori::Pomodoro.new( options )
    end

    def run
      pomodori.save
    end
  end
end
