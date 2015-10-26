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

Wallet = Account[1]

Wallet.add_transaction(amount: -12, description: 'Subway').add_tag(food)
Wallet.add_transaction(amount: -6.45, description: 'Magic Wok').add_tag(food)
Wallet.add_transaction(amount: -7.67, description: 'Humble Bundle').add_tag(entertainment)
Wallet.add_transaction(amount: -12, description: 'Subway').add_tag(food)
Wallet.add_transaction(amount: -10, description: 'Digital Ocean').add_tag(business)
Wallet.add_transaction(amount: 100, description: '100 dollars from parents').add_tag(income)

user.add_budget(:name => "Food", :spending_limit => 100)
user.add_budget(:name => "Entertainment", :spending_limit => 50)
user.add_budget(:name => "Misc", :spending_limit => 50)
