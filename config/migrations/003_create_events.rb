Sequel.migration do
  up do
    create_table(:events) do
      primary_key   :id
      String        :summary
      Integer       :duration

      DateTime      :created_at
      DateTime      :completed_at

      foreign_key   :event_type_id, :event_types
      foreign_key   :state_id,      :states
      
      index         :created_at
    end
  end
  
  down do 
    drop_table(:events)
  end
end
