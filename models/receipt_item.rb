class ReceiptItem < Sequel::Model(:receipt_items)
  many_to_one :receipt
end