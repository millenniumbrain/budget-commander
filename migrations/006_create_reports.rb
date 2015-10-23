Sequel.migration do
  up do
    create_table :reports do
      primary_key :id
      Integer :budget_balance
      DateTime :created_at
      DateTime :updated_at

      foreign_key :user_id
    end
  end

  down do
    drop_table :reports
  end
end
