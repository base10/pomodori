#-*- mode: ruby; x-counterpart: ../../spec/lib/pausa_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

module Pomodori

  # A short break. Defaults to 5 minutes
  # See Pomodori::Event for most of the interface info
  class Pausa < Pomodori::Event
    # TODO: class method that determines the next type of break and returns
    # the appropriate object (pausa or lunga_pausa)

    def add_start_notifications
    end

    def add_cancel_notifications
    end

    def add_save_notifications
    end
  end
end
