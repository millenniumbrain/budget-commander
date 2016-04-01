require './models'

user = User.new do |u|
  u.email = 'example@email.com'
  u.name = 'test'
  u.password = 'password'
end

user.save
account = Account.create(:name => 'Wallet', :user_id => user.id)
clothes = Tag.create(:name => 'Clothes', :user_id => user.id)
hardware = Tag.create(:name => 'Hardware', :user_id => user.id)
gardening = Tag.create(:name => 'Gardening', :user_id => user.id)

shopping = Budget.create do |b|
  b.name = "Shopping"
  b.spending_limit = 200
  b.user_id = user.id
end
shopping.add_tag(gardening)
shopping.add_tag(clothes)
work = Budget.create do |b|
  b.name = "Work"
  b.spending_limit = 500
  b.user_id = user.id
end
work.add_tag(hardware)

one = Transaction.create do |t|
  t.date = 'Oct 16 2015'
  t.amount = 57.45
  t.type = 'expense'
  t.description = 'Income'
  t.account_id = account.id
  t.user_id =  user.id
end
one.add_tag(clothes)
two = Transaction.create do |t|
  t.date = 'Mar 26 2016'
  t.amount = 100
  t.type = 'income'
  t.description = 'Income'
  t.account_id = account.id
  t.user_id =  user.id
end
two.add_tag(hardware)
three = Transaction.create do |t|
  t.date = 'Mar 6 2016'
  t.amount = 10.89
  t.type = 'expense'
  t.description = 'Chocolate Moose'
  t.account_id = account.id
  t.user_id =  user.id
end
three.add_tag(hardware)
four = Transaction.create do |t|
  t.date = 'Mar 26 2015'
  t.amount = 25.23
  t.type = 'expense'
  t.description = 'Polygon'
  t.account_id = account.id
  t.user_id =  user.id
end
four.add_tag(gardening)
