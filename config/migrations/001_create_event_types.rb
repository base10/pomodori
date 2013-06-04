Sequel.migration do
  up do
    create_table(:event_types) do
      primary_key   :id    
      String        :name
    end

    #     enum          :event_type,  :elements => ['pomodoro', 'break', 'long_break']
  end
  
  down do
    drop_table(:event_types)
  end
end
