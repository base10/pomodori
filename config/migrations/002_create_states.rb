Sequel.migration do
  up do
    create_table(:states) do
      primary_key   :id
      String        :name
    end

    #     enum          :state,       :elements => ['complete', 'aborted', 'in_progress']
  end
  
  down do
    drop_table(:states)
  end
end
