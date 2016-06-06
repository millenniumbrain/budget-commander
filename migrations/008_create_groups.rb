Sequel.migration do
  up do
    create_table :groups do
      primary_key :id
      String :_id, :null => false
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
