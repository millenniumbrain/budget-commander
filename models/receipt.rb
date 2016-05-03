class Receipt < Sequel::Model(:receipts)
  plugin :json_serializer
  one_to_many :receipt_items
  many_to_one :user
  many_to_one :group
end