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
