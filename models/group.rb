class Group < Sequel::Model(:groups)
    many_to_many :users
    one_to_many :budgets
    one_to_many :transactions
    one_to_many :receipts
    one_to_many :tags
end