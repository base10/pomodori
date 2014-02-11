#-*- mode: ruby; x-counterpart: ../../spec/lib/lunga_pausa_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

module Pomodori

  # A long break after a complete set of Pomodori and Pausas.
  # Defaults to 15 minutes.
  # See Pomodori::Event for the interface info
  class LungaPausa < Pomodori::Event
    def add_start_notifications
    end

    def add_cancel_notifications
    end

    def add_save_notifications
    end
  end
end
