Sequel.migration do
  up do
    create_table :transactions do
      primary_key :id
      Numeric :amount
      String :description
      String :type
      DateTime :date
      DateTime :created_at
      DateTime :updated_at
      foreign_key :user_id
      foreign_key :account_id
    end
  end

  down do
    drop_table :transactions
  end
end
