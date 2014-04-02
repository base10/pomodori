#-*- mode: ruby; x-counterpart: ../../spec/lib/lunga_pausa_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

module Pomodori

  # A long break after a complete set of Pomodori and Pausas.
  # Defaults to 15 minutes.
  # See Pomodori::Event for the interface info
  class LungaPausa < Pomodori::Event
    def add_start_notifications
      now = DateTime.now

      draft_notifications = [
        { action: "Started",      deliver_at: now },
        { action: "Done",         deliver_at: now + 15.minutes }
      ]

      draft_notifications.each do |draft_notice|
        draft_notice[:event]  = self
        notice                = Pomodori::Notification.new( draft_notice )
        notice.save

        state_notifications.push notice
      end
    end

  end
end
