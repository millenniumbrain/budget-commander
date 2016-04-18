Sequel.migration do
  up do
    create_table :groups do
      primary_key :id
      String :name
      String :phone_number
      DateTime :created_at
      DateTime :updated_at
    end
  end
  
  down do
    drop_table :groups
  end
end