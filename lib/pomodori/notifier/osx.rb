#-*- mode: ruby; x-counterpart: ../../../spec/lib/notifier/osx_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

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
