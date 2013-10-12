# Snippets from testing transitions and workflow gems

  state_machine do
    state :ready
    state :in_progress
    state :cancelled
    state :completed

    event :start do
      transitions :to => :in_progress, :from => :ready, :guard => :can_start?
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
