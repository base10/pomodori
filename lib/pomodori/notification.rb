# actions: start, halfway, close, complete, cancel

require 'pp'

module Pomodori
  database  = Pomodori::Database.new
  DB        = database.connect

  class Notification < Sequel::Model
    def validate
      validate_action
      validate_deliver_at

      super
    end

    def validate_action
      errors.add(:action, "can't be nil")   if action.nil?
      errors.add(:action, "can't be empty") if action.respond_to?(:empty?) && action.empty?
    end

    def validate_deliver_at
      errors.add(:deliver_at, "can't be nil") if deliver_at.nil?
    end
  end
end
