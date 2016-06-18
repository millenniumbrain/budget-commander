Sequel.migration do
  up do
    create_table :tags do
      primary_key :id
      String :_id, :null => false
      String :name, length: 20
      TrueClass :budget, :default => false
      Integer :spending_limit
      foreign_key :user_id
      foreign_key :group_id
    end
  end

  down do
    drop_table :tags
  end
end
