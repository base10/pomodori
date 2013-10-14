# kinds:    'pomodoro', 'pausa', 'lungo_pausa'
# States:   'new', 'completed', 'cancelled', 'in_progress'

require 'pp'
require 'micromachine'

module Pomodori
  database  = Pomodori::Database.new
  DB        = database.connect
  CONFIG    = database.config

  class Event < Sequel::Model(:events)
    # FIXME: I need to rethink using initialize in a composed module when I'm
    # inheriting something that also provides initialize
    #include Pomodori::Configure
    attr_accessor :config

    # TODO: define scopes

    def initialize(values = {})
      @config           = CONFIG

      values[:kind]     = determine_kind
      values[:state]    = "ready"
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

    def transition
      @transition ||= begin
        state_machine = MicroMachine.new( state || "ready" )

        state_machine.when(:start,    "ready"       => "in_progress")
        state_machine.when(:cancel,   "ready"       => "canceled",
                                      "in_progress" => "canceled")
        state_machine.when(:complete, "in_progress" => "completed")

        state_machine.on(:any) { self.state = transition.state }

        state_machine
      end
    end

    def state_change


    end

    def start
      if transition.trigger?(:start)
        transition.trigger(:start)
        self.started_at = DateTime.now

        self.save
      end
    end

    def cancel
      if transition.trigger?(:cancel)
        transition.trigger(:cancel)
        self.canceled_at = DateTime.now

        self.save
      end
    end

    def complete
      if transition.trigger?(:complete)
        transition.trigger(:complete)
        self.completed_at = DateTime.now

        self.save
      end
    end
  end
end
