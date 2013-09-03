# kinds:    'pomodoro', 'pausa', 'lungo_pausa'
# States:   'new', 'completed', 'cancelled', 'in_progress'

require 'pp'
require 'transitions'

module Pomodori
  database  = Pomodori::Database.new
  DB        = database.connect
  CONFIG    = database.config

  class Event < Sequel::Model(:events)
    include Transitions

    # FIXME: I need to rethink using initialize in a composed module when I'm
    # inheriting something that also provides initialize
    #include Pomodori::Configure
    attr_accessor :config

    # TODO: define scopes

    def initialize(values = {})
      @config           = CONFIG

      values[:kind]     = determine_kind
      values[:state]    = 'ready'
      values[:duration] = @config[determine_kind]['duration']
      values[:summary]  = @config[determine_kind]['summary']

      super(values)
    end

    def determine_kind
      klass     = self.class.to_s
      hierarchy = klass.split(/\:\:/)
      kind      = hierarchy.pop.to_underscore
      kind      = kind.downcase
      
      kind
    end

    def before_validation
      if values[:created_at].nil?
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

    state_machine do
      state :ready
      state :in_progress
      state :cancelled
      state :completed

      event :start do
        transitions :to => :in_progress, :from => :ready
          # TODO: guard, no more than one in_progress event
          # TODO: on_transition, create the necessary events

      end
 
      event :cancel do
        transitions :to => :cancelled, :from => :in_progress
          # TODO: guard for in_progress only
          # TODO: Cancel outstanding notifications
          # TODO: Mark event as cancelled
      end
    
      event :complete do
        transitions :to => :completed, :from => :in_progress
          # TODO: guard for in_progress only
          # TODO: Mark event as complete
      end
    end

    # begin
    # after_begin
    # mark_complete
    # after_complete
    # mark_incomplete
      # If it's a Pomodoro, invalidate the next break
    # after_incomplete
  end
end
