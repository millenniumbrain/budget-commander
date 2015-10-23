class Budget < Sequel::Model(:budgets)
  many_to_one :user
  many_to_many :tags
end
