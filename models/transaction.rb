class Transaction < Sequel::Model(:transactions)
  plugin :json_serializer
  many_to_one :user
  many_to_one :account
  many_to_many :tags
end
