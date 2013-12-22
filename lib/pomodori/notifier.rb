module Pomodori
  module Notifier
    attr_accessor :notification, :output

    def initialize( options )
      @notification = options.fetch(:notification)
      @output       = options.fetch(:output) { STDOUT }
    end

    def deliver
      raise Pomodori::Notifier::Error, "This method needs to be overwritten"
    end
  end
end
