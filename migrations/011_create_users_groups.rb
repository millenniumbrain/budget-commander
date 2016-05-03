Sequel.migration do
  up do
    create_table :users_groups do
      primary_key :id
      foreign_key :user_id
      foreign_key :group_id
    end
  end
  
  down do
    drop_table(:users_groups)
  end
end