module Pomodori
  # Base module for delivering notifications
  module Notifier
    attr_accessor :notification, :output

    # Builds a Pomodori::Notifier object (this is a base class)
    # @param options [Hash]
    #   - notification: A Pomodori::Notification object
    #   - output: Where a notification is going to go (defaults to STDOUT)
    #       Used primarily for testing
    def initialize( options )
      @notification = options.fetch(:notification)
      @output       = options.fetch(:output) { STDOUT }
    end

    # API declaration. See concrete classes.
    def deliver
      raise Pomodori::Notifier::Error, "This method needs to be overwritten"
    end
  end
end
