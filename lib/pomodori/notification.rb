#-*- mode: ruby; x-counterpart: ../../spec/lib/notification_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

# actions: start, halfway, close, complete, cancel

require 'pp'

module Pomodori
  CONFIGURATION = Pomodori::Configuration.new
  database      = Pomodori::Database.new( { configuration: CONFIGURATION } )
  DB            = database.connect

  # Builds a new Pomodori::Notification object to handles notifications
  # from events
  class Notification < Sequel::Model
    many_to_one :event

    attr_accessor :output, :delay

    # Builds a new Pomodori::Notification object. These are tied to Events.
    # @param options [Hash]
    #   - action: [String] What action the notification is for (starting, finishing, canceling, etc)
    #   - deliver_at: [DateTime] When the notification should be delivered
    #   - event: [Pomodori::Pomodoro, Pomodori::Pausa, Pomodori::LungoPausa]
    #   - output: [IO, nil] Defaults to STDOUT. Otherwise useful for unit testing
    # @return A new Pomodori::Notification object
    def initialize( options = {} )
      @output = options.fetch(:output, STDOUT)
      @delay  = 0 #default delay

      super
    end

    # Determines which notifier to use to deliver the notification
    # @return [String] classname of the Notifier to use
    def notifier_strategy
      strategy_pref   = CONFIGURATION.config['notifier']
      strategy_class  = 'Pomodori::Notifier::' + strategy_pref.camelcase
    end

    def process
      return if processed?

      calculate_delay
      add_delay
      deliver
    end

    def processed?
      if self.completed_at.to_datetime
        return true
      end

      false
    rescue NoMethodError => e
      false
    end

    def calculate_delay
      now_seconds         = DateTime.now.strftime("%s").to_i
      deliver_at_seconds  = self.deliver_at.strftime("%s").to_i
      tmp_delay           = deliver_at_seconds - now_seconds
      @delay              = tmp_delay >= 1 ? tmp_delay : 0
    end

    def add_delay
      sleep self.delay
    end

    # Delivers a notification with the appropriate notifier and marks
    # the notification as complete
    def deliver
      options = {
                  notification: self,
                  output:       output
                }

      notifier = eval(notifier_strategy).new( options )
      notifier.deliver

      self.completed_at = DateTime.now
      self.save
    end

    # Provides a title for the notification
    def title
      "#{event.kind} #{action}"
    end

    # The core message of the notification
    def message
      "#{event.kind}"
    end

    # Public API ends here
    protected

    # Ensure we have a valid object
    def validate
      validate_action
      validate_deliver_at
      validate_event_id

      super
    end

    def validate_action
      errors.add(:action, "can't be nil")   if action.nil?
      errors.add(:action, "can't be empty") if action.respond_to?(:empty?) && action.empty?
    end

    def validate_deliver_at
      errors.add(:deliver_at, "can't be nil") if deliver_at.nil?
    end

    def validate_event_id
      if event.kind_of?(Pomodori::Event)
        event_id = event.id
      end

      errors.add(:event_id, "can't be nil") if event_id.nil?
    end
  end
end
