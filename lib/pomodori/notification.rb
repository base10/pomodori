# actions: start, halfway, close, complete, cancel

require 'pp'
require 'terminal-notifier'

module Pomodori
  database  = Pomodori::Database.new
  DB        = database.connect

  class Notification < Sequel::Model
    attr_accessor :event

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

    def message
      "#{action.upcase}"
    end
  end
end
