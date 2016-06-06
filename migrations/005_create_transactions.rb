Sequel.migration do
  up do
    create_table :transactions do
      primary_key :id
      String :_id, :null => false
      BigDecimal :amount, :size => [19, 4], :null => false
      String :description
      String :type
      String :currency, :default => "USD"
      DateTime :date
      DateTime :created_at
      DateTime :updated_at
      foreign_key :user_id
      foreign_key :group_id
      foreign_key :account_id
    end
  end

  down do
    drop_table :transactions
  end
end
