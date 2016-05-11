class Tag < Sequel::Model(:tags)
  plugin :json_serializer
  many_to_one :user
  many_to_many :budgets
  many_to_many :transactions
end
