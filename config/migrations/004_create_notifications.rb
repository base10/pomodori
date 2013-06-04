Sequel.migration do
  up do
    create_table(:notifications) do
      primary_key   :id

      enum          :action, :elements => ['complete', 'halfway']

      DateTime      :deliver_at
      DateTime      :completed_at

      foreign_key :event_id, :events
      
      index :action
      index :deliver_at
      index :completed_at
    end
  end
  
  down do 
    drop_table(:notifications)
  end
end
