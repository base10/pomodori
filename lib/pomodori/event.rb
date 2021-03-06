#-*- mode: ruby; x-counterpart: ../../spec/lib/pomodoro_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

require 'micromachine'
require 'verbs'
require 'date'

module Pomodori
  # A base class to handle three types of Events in Pomodori
  #
  # - Pomodoro: A (25 minute) working session
  # - Pausa: A short (five minute) break
  # - LungaPausa: A longer (15 minute) break
  #
  # Events can exist in four states:
  #
  # - new: Created, but not yet started
  # - in_progress: In-flight, but not resolved
  # - completed: Successfully finished
  # - cancelled: Aborted while in-flight
  class Event < Sequel::Model(:events)
    attr_accessor :configuration, :state_notifications
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

      values[:kind]     = self.class.determine_kind
      values[:state]    = "ready"
      values[:duration] = options.fetch('duration') { get_duration }
      values[:summary]  = options.fetch('summary')  { get_summary }

      @state_notifications = Array.new

      super(values)
    end

    # Retrieve a list of event objects (Pomodoro, Pausa, LungaPausa) completed
    # today.
    #
    # @return [Array] A list of Pomodoro, Pausa, LungaPausa objects
    # (depending on class)
    def self.done_today
      now       = DateTime.current
      begin_ds  = now.beginning_of_day
      end_ds    = now.end_of_day

      kind      = self.determine_kind

      self.where(:kind => kind).where(:completed_at => begin_ds .. end_ds).all
    end

    # @return [Fixnum] the (default) duration in minutes for the event
    def get_duration
      configuration.get_duration( self.class.determine_kind )
    end

    # @return [String] the (default) summary for the event
    def get_summary
      configuration.get_summary( self.class.determine_kind )
    end

    # @return [String] Converts class to a string.
    #   Used to get information from Pomodori::Configuration
    def self.determine_kind
      klass     = self.to_s
      hierarchy = klass.split(/\:\:/)
      kind      = hierarchy.pop.to_underscore
      kind      = kind.downcase

      kind
    end

    # Tell an event to begin
    def start
      state_change(:start) if transition.trigger?(:start)
      add_start_notifications
      run                       # TODO: Maybe there's a block here?
      clear_state_notifications
    end

    def add_start_notifications
      raise NotImplementedError, "This #{self.class} cannot respond to:"
    end

    # Cancel a running event
    def cancel
      state_change(:cancel) if transition.trigger?(:cancel)
      add_cancel_notifications
      run
      clear_state_notifications
    end

    def add_cancel_notifications
      notice = Pomodori::Notification.new({
                action:     "Cancelled!",
                deliver_at: DateTime.now,
                event:      self
              })

      notice.save
      state_notifications.push notice
    end

    # Complete a running event
    def complete
      state_change(:complete) if transition.trigger?(:complete)
      add_save_notifications
      run
      clear_state_notifications
    end

    def add_save_notifications
      notice = Pomodori::Notification.new({
                action:     "Completed!",
                deliver_at: DateTime.now,
                event:      self
              })

      notice.save
      state_notifications.push notice
    end

    def save!
      save
    end

    def run
      state_notifications.each do |notice|
        notice.process
      end
    end

    # Public API ends here
    protected

    def clear_state_notifications
      @state_notifications = Array.new
    end

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

      # TODO: Kickoff transition tasks
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
