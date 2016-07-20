Sequel.migration do
  up do
    create_table :tags_transactions do
      primary_key :id
      foreign_key :tag_id
      foreign_key :transaction_id
    end
  end

  down do
    drop_table :tags_transactions
  end
end
