Sequel.migration do
  up do
    create_table(:events) do
      primary_key   :id
      String        :summary
      Integer       :duration

      String        :kind
      String        :state

      DateTime      :started_at
      DateTime      :created_at
      DateTime      :completed_at
      DateTime      :canceled_at

      index         :created_at
      index         :kind
      index         :state
    end
  end

  down do
    drop_table(:events)
  end
end
