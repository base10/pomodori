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
    attr_accessor :config, :database

    def after_initialize
      super
      @config = CONFIG
    end

    def kind
    
    end

    def kind=( thing )
  
    end

    def state
    
    end

    def validate
      super
      
      validate_summary
    end

    def validate_summary
      errors.add(:summary, "can't be nil")   if summary.nil?
      errors.add(:summary, "can't be empty") if summary.respond_to?(:empty?) && summary.empty?
    end

    # begin
    # mark_complete
    # mark_incomplete
  end
end
