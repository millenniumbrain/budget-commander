Sequel.migration do
  up do
    create_table :tags do
      primary_key :id
      String :name, length: 20
      String :category
      foreign_key :user_id
    end
  end

  down do
    drop_table :tags
  end
end
