#-*- mode: ruby; x-counterpart: ../../spec/lib/pomodoro_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

module Pomodori
  # The main unit of work. Defaults to a 25 minute duration
  # See Pomodori::Event for interface info
  class Pomodoro < Pomodori::Event
    def add_start_notifications
    end

    def add_cancel_notifications
    end

    def add_save_notifications
    end
  end
end
