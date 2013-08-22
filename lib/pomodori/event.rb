# TODO: Each event will have to declare a type
# TODO: Acceptable states will be defined. 
# In both cases above, this is to work around sqlite's lack of enum fields

# kinds:    'pomodoro', 'break', 'long_break'
# States:   'complete', 'aborted', 'in_progress'

require 'pp'

module Pomodori
  database  = Pomodori::Database.new
  DB        = database.connect
  CONFIG    = database.config

  class Event < Sequel::Model(:events)
    # FIXME: I need to rethink using initialize in a composed module when I'm
    # inheriting something that also provides initialize
    #include Pomodori::Configure
    attr_accessor :config

    def initialize(values = {})
      values[:state]  = 'new'

      super(values)
      @config = CONFIG
    end

    def kind
      raise "Called abstract method: kind"
    end

    def before_validation
      if values[:created_at].nil? || values[:created_at].empty?      
        values[:created_at] = DateTime.now
      end
    end

    def validate
      validate_summary
      validate_duration
      validate_kind
      validate_state
      validate_created_at

      super
    end

    def validate_summary
      errors.add(:summary, "can't be nil")   if summary.nil?
      errors.add(:summary, "can't be empty") if summary.respond_to?(:empty?) && summary.empty?
    end

    def validate_duration
      errors.add(:duration, "can't be nil") if duration.nil?
    end

    def validate_kind
      errors.add(:kind, "can't be nil") if kind.nil?
    end

    def validate_state
      errors.add(:state, "can't be nil")   if state.nil?
      errors.add(:state, "can't be empty") if state.respond_to?(:empty?) && state.empty?
    end

    def validate_created_at
      errors.add(:created_at, "can't be nil")   if created_at.nil?
    end

    # begin
    # after_begin
    # mark_complete
    # after_complete
    # mark_incomplete
    # after_incomplete
  end
end
