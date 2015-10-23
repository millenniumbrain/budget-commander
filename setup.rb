require './models'

test_user = User.new do |u|
  u.email = 'example@email.com'
  u.first_name = 'Steve'
  u.last_name = 'Jobs'
  u.name = 'MillenniumBrain'
  u.password = 'password'
end

test_user.save

user = User[1]

food = DB[:tags].insert(:name => 'Food')
user.add_account(name: 'Wallet')

Wallet = Account[1]

Wallet.add_transaction(amount: 12, description: 'Subway').add_tag(food)
Wallet.add_transaction(amount: 6.45, description: 'Magic Wok').add_tag(food)
Wallet.add_transaction(amount: 7.67, description: 'Humble Bundle').add_tag(food)
Wallet.add_transaction(amount: 12, description: 'Subway').add_tag(food)
Wallet.add_transaction(amount: 10, description: 'Digital Ocean').add_tag(food)