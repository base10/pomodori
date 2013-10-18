module Pomodori
  class Notifier
    attr_accessor :notification, :output

    def initialize( options )
      @notification = options[:notification]
      @output       = options[:output]            || STDOUT
    end

    def deliver
      raise ::Error, "This method needs to be overwritten"
    end
  end

  module Notifier
    class Error < StandardError
    end
  end
end


