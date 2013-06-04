Sequel.migration do
  up do
    create_table(:events) do
      primary_key   :id
      String        :summary
      Integer       :duration
      enum          :event_type,  :elements => [ 'Pomodoro', 'Break', 'LongBreak']
      enum          :state,       :elements => [ 'complete', 'aborted', 'in_progress' ]
      DateTime      :created_at
      DateTime      :completed_at
      
      index :event_type
      index :created_at
    end
  end
  
  down do 
    drop_table(:events)
  end
end
