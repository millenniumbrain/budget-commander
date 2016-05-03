Sequel.migration do
  up do
    create_table :receipts do
      primary_key :id
      String :img_url
      DateTime :date
      String :memo
      DateTime :created_at
      DateTime :updated_at
      foreign_key :user_id
    end
  end
  
  down do
    drop_table(:receipts)
  end
end