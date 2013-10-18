module Pomodori
  module Notifier
    attr_accessor :notification, :output

    def initialize( options )
      unless options.has_key?(:notification)
        raise Pomodori::Notifier::Error, "Needs a notification"
      end

      @notification = options[:notification]
      @output       = options[:output] || STDOUT
    end

    def deliver
      raise Pomodori::Notifier::Error, "This method needs to be overwritten"
    end
  end
end
