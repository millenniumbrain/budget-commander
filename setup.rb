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

user.add_transaction(
  :amount => 100.00,
  :description => 'Money',
  :type => 'income',
  :date => Time.now,
  :account_id => 1)
user.add_transaction(
  :amount => 25.24,
  :description => 'Money',
  :type => 'income',
  :date => Time.now,
  :account_id => 1)

user.add_transaction(
  :amount => 6.45,
  :type => 'expense',
  :description => 'Subway',
  :date => Time.now,
  :account_id => 1)

user.add_transaction(
  :amount => 10.00,
  :type => 'expense',
  :description => 'Magic the Gathering Cards',
  :date => Time.now,
  :account_id => 1)

user.add_transaction(
  :amount => 9.58,
  :type => 'expense',
  :description => 'Magic Wok',
  :date => Time.now,
  :account_id => 1)
