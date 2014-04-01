#-*- mode: ruby; x-counterpart: ../../spec/lib/pomodoro_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

module Pomodori
  # The main unit of work. Defaults to a 25 minute duration
  # See Pomodori::Event for interface info
  class Pomodoro < Pomodori::Event
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

    def add_cancel_notifications
      notice = Pomodori::Notification.new({
                action:     "Cancelled!",
                deliver_at: DateTime.now,
                event:      self
              })

      notice.save
      state_notifications.push notice
    end

    def add_save_notifications
      notice = Pomodori::Notification.new({
                action:     "Completed!",
                deliver_at: DateTime.now,
                event:      self
              })

      notice.save
      state_notifications.push notice
    end
  end
end
