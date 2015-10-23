Sequel.migration do
  up do
    create_table :budgets do
      primary_key :id
      String :name, length: 20
      Integer :spending_limit
      foreign_key :user_id
    end
  end

  down do
    drop_table :budgets
  end
end
