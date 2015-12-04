require './models'

test_user = User.new do |u|
  u.email = 'example@email.com'
  u.name = 'test'
  u.password = 'password'
end

test_user.save

user = User[1]

food = DB[:tags].insert(:name => 'Food')
business = DB[:tags].insert(:name => 'Business')
entertainment = DB[:tags].insert(:name => 'Entertainment')
income = DB[:tags].insert(:name => 'Income')

user.add_account(name: 'Wallet')
user.add_budget(:name => "Food", :spending_limit => 100)
user.add_budget(:name => "Entertainment", :spending_limit => 50)
user.add_budget(:name => "Misc", :spending_limit => 50)
