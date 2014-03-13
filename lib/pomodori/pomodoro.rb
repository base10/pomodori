#-*- mode: ruby; x-counterpart: ../../spec/lib/pomodoro_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

module Pomodori
  # The main unit of work. Defaults to a 25 minute duration
  # See Pomodori::Event for interface info
  class Pomodoro < Pomodori::Event
    def add_start_notifications
      now = DateTime.now
      n1  = Notification.new({  action:     "Started",
                                deliver_at: now,
                                event:      self
                            })

      n2  = Notification.new({  action:     "Halfway!",
                                deliver_at: now + 13.minutes,
                                event:      self
                            })

      n3  = Notification.new({  action:     "Almost Done",
                                deliver_at: now + 20.minutes,
                                event:      self
                            })

      n4  = Notification.new({  action:     "Done",
                                deliver_at: now + 25.minutes,
                                event:      self
                             })

      [n1, n2, n3, n4].each do |notice|
        notice.save
      end
    end

    def add_cancel_notifications
    end

    def add_save_notifications
    end
  end
end
