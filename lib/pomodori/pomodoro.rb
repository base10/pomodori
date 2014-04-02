#-*- mode: ruby; x-counterpart: ../../spec/lib/pomodoro_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

module Pomodori
  # The main unit of work. Defaults to a 25 minute duration
  # See Pomodori::Event for interface info
  class Pomodoro < Pomodori::Event

    # FIXME: Doesn't properly handle time (if, for instance, user sets
    # Pomodoro instance to 22 minutes, the "done" notification is *late*)
    def add_start_notifications
      now = DateTime.now

      draft_notifications = [
        { action: "Started",      deliver_at: now },
        { action: "Halfway!",     deliver_at: now + 13.minutes },
        { action: "Almost Done",  deliver_at: now + 20.minutes },
        { action: "Done",         deliver_at: now + 25.minutes }
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
