Sequel.migration do
  up do
    create_table :budgets do
      primary_key :id
      String :_id, :null => false
      String :name, length: 20
      Integer :spending_limit
      TrueClass :rollover
      foreign_key :user_id
      foreign_key :group_id
    end
  end

  down do
    drop_table :budgets
  end
end
