require 'rspec/expectations'
require 'rspec/core'

describe User do
  let(:user) do
    user = User.new do |u|
      u.email = 'test@example.com'
      u.name = 'Bob'
      u.password = 'test'
    end
    user.save
  end

  context 'when associations are correct' do
    it 'has accounts' do
      expect(user.accounts).to eq []
    end

    it 'has budgets' do
      expect(user.budgets).to eq []
    end

    it 'has tags' do
      expect(user.tags).to eq []
    end

    it 'has transactions' do
      expect(user.transactions).to eq []
    end
  end
end

describe Account do
   let(:user) do
    user = User.new do |u|
      u.email = 'test@example.com'
      u.name = 'Bob'
      u.password = 'test'
    end
    user.save
  end 
  let(:account) { Account.create(:name => 'Wallet', :user_id => user.id) }

  context 'when associations are correct' do
    it 'has transactions' do
      expect(account.transactions).to eq []
    end

    it 'belongs to a user' do
      expect(account.user.class).to eq User
    end
  end
end

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
    Transaction.create(:date => 'Oct 12 2016', 
                       :amount => 100.00, 
                       :type => 'income', 
                       :description => 'Income',
                       :account_id => account.id,
                       :user_id => user.id)
  end

  context 'when associations are correct' do
    it 'belongs to an account' do
      expect(transaction.account.class).to eq Account
    end

    it 'belongs to a user' do
      expect(transaction.user.class).to eq User
    end
  end
end

describe Tag do
end

describe Budget do
end
