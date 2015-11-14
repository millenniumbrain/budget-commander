class Budget < Sequel::Model(:budgets)
  plugin :json_serializer
  many_to_one :user
  #many_to_many :tags
end
