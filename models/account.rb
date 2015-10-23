class Account < Sequel::Model(:accounts)
  plugin :json_serializer
  
  many_to_one :user
  one_to_many :transactions
end
