#-*- mode: ruby; x-counterpart: ../../spec/lib/pomodoro_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

# kinds:    'pomodoro', 'pausa', 'lungo_pausa'
# States:   'new', 'completed', 'cancelled', 'in_progress'

require 'pp'
require 'micromachine'
require 'verbs'

module Pomodori
  CONFIGURATION = Pomodori::Configuration.new

  database  = Pomodori::Database.new( { configuration: CONFIGURATION } )
  DB        = database.connect

  class Event < Sequel::Model(:events)
    # FIXME: I need to rethink using initialize in a composed module when I'm
    # inheriting something that also provides initialize
    #include Pomodori::Configure
    attr_accessor :configuration
    one_to_many   :notifications

    # TODO: define scopes

    def initialize(values = {})
      @configuration    = CONFIGURATION

      values[:kind]     = determine_kind
      values[:state]    = "ready"
      values[:duration] = @configuration.config[determine_kind]['duration']
      values[:summary]  = @configuration.config[determine_kind]['summary']

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
        state_machine.when(:cancel,   "ready"       => "cancelled",
                                      "in_progress" => "cancelled")
        state_machine.when(:complete, "in_progress" => "completed")

        state_machine.on(:any) { self.state = transition.state }

        state_machine
      end
    end

    def time_method(state)
      method = Verbs::Conjugator.conjugate state, tense: :past, aspect: :perfective
      method += '_at='
    end

    def state_change(method)
      transition.trigger(method)

      self.send(time_method( method ), DateTime.now)
      self.save

      # kickoff transition tasks
    end

    def start
      state_change(:start) if transition.trigger?(:start)
    end

    def cancel
      state_change(:cancel) if transition.trigger?(:cancel)
    end

    def complete
      state_change(:complete) if transition.trigger?(:complete)
    end
  end
end
