Sequel.migration do
  up do
    create_table(:receipt_items) do
      primary_key :id
      String :name
      Integer :quantity, :default => 0
      BigDecimal :price, :size => [19, 4]
      foreign_key :receipt_id
    end
  end
  
  down do
    drop_table(:receipt_entries)
  end
end