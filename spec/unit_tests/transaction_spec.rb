require 'rspec/expectations'
require 'rspec/core'

describe Transaction do
  let(:user) do
    user = User.new do |u|
      u.email = 'test@example.com'
      u.name = 'Bob'
      u.password = 'test'
    end
    user.save
  end
  let(:account) { Account.create(:name => 'Wallet', :user_id => user.id) }
  let(:transaction) do
    Transaction.create do |t|
      t.date = 'Oct 12 2016'
      t.amount = 100.00
      t.type = 'income'
      t.description = 'Income'
      t.account_id = account.id
      t.user_id = user.id
    end
  end

  let!(:transactions) do
    Transaction.create do |t|
      t.date = 'Oct 16 2015'
      t.amount = 100
      t.type = 'income'
      t.description = 'Income'
      t.account_id = account.id
      t.user_id =  user.id
    end
    Transaction.create do |t|
      t.date = 'Mar 26 2016'
      t.amount = 100
      t.type = 'income'
      t.description = 'Income'
      t.account_id = account.id
      t.user_id =  user.id
    end
    Transaction.create do |t|
      t.date = 'Mar 6 2016'
      t.amount = 10.89
      t.type = 'expensive'
      t.description = 'Chocolate Moose'
      t.account_id = account.id
      t.user_id =  user.id
    end
    Transaction.create do |t|
      t.date = 'Mar 26 2015'
      t.amount = 25.23
      t.type = 'expense'
      t.description = 'Polygon'
      t.account_id = account.id
      t.user_id =  user.id
    end
  end

  context 'when associations are correct' do
    it 'belongs to an account' do
      expect(transaction.account.class).to eq Account
    end

    it 'belongs to a user' do
      expect(transaction.user.class).to eq User
    end

    it 'has tags' do
      expect(transaction.tags).to eq []
    end
  end

  context 'when retriving totals' do
    it 'has an income this month' do
      expect(Transaction.current_month_total(user.id, 'income')).to eql 100.0
    end

    it 'has an income' do
      expect(Transaction.total(user.id, 'income')).to eq 200
    end
  end
end
