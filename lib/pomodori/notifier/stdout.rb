#-*- mode: ruby; x-counterpart: ../../../spec/lib/notifier/stdout_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

module Pomodori
  module Notifier
    class Stdout
      include Pomodori::Notifier

      def deliver
        output.puts notification.title
        output.puts notification.message
      end
    end
  end
end
