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

  # A base class to handle three types of Events in Pomodori
  #
  # - Pomodoro: A (25 minute) working session
  # - Pausa: A short (five minute) break
  # - LungaPausa: A longer (15 minute) break
  class Event < Sequel::Model(:events)
    # FIXME: I need to rethink using initialize in a composed module when I'm
    # inheriting something that also provides initialize
    #include Pomodori::Configure
    attr_accessor :configuration
    one_to_many   :notifications

    # TODO: define scopes

    # Builds a new event object (Pomodoro, Pausa, LungaPausa)
    #
    # @param options [Hash] options can contain two keys, duration and summary.
    #   - duration: [Fixnum] Read as minutes to set the event lifespan for
    #   - summary: [String] What going on with this event
    #
    # @return [Object] A Pomodoro, Pausa or LungaPausa object (depending on class)
    def initialize( options = {} )
      @configuration    = CONFIGURATION
      values            = Hash.new

      values[:kind]     = determine_kind
      values[:state]    = "ready"
      values[:duration] = options.fetch('duration') { get_duration }
      values[:summary]  = options.fetch('summary')  { get_summary }

      super(values)
    end

    # @return [Fixnum] the (default) duration in minutes for the event
    def get_duration
      configuration.get_duration( determine_kind )
    end

    # @return [String] the (default) summary for the event
    def get_summary
      configuration.get_summary( determine_kind )
    end

    # @return [String] Converts class to a string.
    #   Used to get information from Pomodori::Configuration
    def determine_kind
      klass     = self.class.to_s
      hierarchy = klass.split(/\:\:/)
      kind      = hierarchy.pop.to_underscore
      kind      = kind.downcase

      kind
    end

    # Tell an event to begin
    def start
      state_change(:start) if transition.trigger?(:start)
    end

    # Cancel a running event
    def cancel
      state_change(:cancel) if transition.trigger?(:cancel)
    end

    # Complete a running event
    def complete
      state_change(:complete) if transition.trigger?(:complete)
    end

    # Public API ends here
    protected

    # Set a default created_at timestamp before we save
    def before_validation
      if values[:created_at].nil?
        values[:created_at] = DateTime.now
      end
    end

    # Ensure we have a valid object
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

    # Supporting method for micromachine, implements the state machine
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
  end
end
