# actions: start, halfway, close, complete, cancel

require 'pp'

module Pomodori
  database  = Pomodori::Database.new
  DB        = database.connect
  CONFIG    = database.config

  class Notification < Sequel::Model
    many_to_one :event

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

    def notifier_strategy
      strategy_pref   = CONFIG['notifier']
      strategy_class  = 'Pomodori::Notifier::' + strategy_pref.camelcase
    end

    def deliver
      # TODO: Get the right kind of notifier
      # Call the delivery method
      # Add tests
    end

    def title
      "#{event.kind} #{action}"
    end

    def message
      "#{event.kind}"
    end
  end
end
