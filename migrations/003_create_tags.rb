Sequel.migration do
  up do
    create_table :tags do
      primary_key :id
      Bignum :uid
      String :name, length: 20
      foreign_key :user_id
    end
  end

  down do
    drop_table :tags
  end
end
