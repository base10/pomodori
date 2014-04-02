#-*- mode: ruby; x-counterpart: ../../spec/lib/pausa_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

module Pomodori

  # A short break. Defaults to 5 minutes
  # See Pomodori::Event for most of the interface info
  class Pausa < Pomodori::Event
    # TODO: class method that determines the next type of break and returns
    # the appropriate object (pausa or lunga_pausa)

    def add_start_notifications
      now = DateTime.now

      draft_notifications = [
        { action: "Started",      deliver_at: now },
        { action: "Done",         deliver_at: now + 5.minutes }
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
