require 'terminal-notifier'

module Pomodori
  module Notifier
    class Osx
      include Pomodori::Notifier

      def deliver
        title   = notification.title
        message = notification.message

        TerminalNotifier.notify(message, title: title )
      end
    end
  end
end
