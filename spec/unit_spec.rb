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

describe Tag do
  let(:user) do
    user = User.new do |u|
      u.email = 'test@example.com'
      u.name = 'Bob'
      u.password = 'test'
    end
    user.save
  end

  let(:tag) { Tag.create(:name => 'Entertainment', :user_id => user.id) }

  context 'when associations are correct' do
    it 'belongs to a user' do
      expect(tag.user.class).to eq User
    end

    it 'has budgets' do
      expect(tag.budgets).to eq []
    end

    it 'has transactions' do
      expect(tag.transactions).to eq []
    end
  end
end

describe Budget do
  let(:user) do
    user = User.new do |u|
      u.email = 'test@example.com'
      u.name = 'Bob'
      u.password = 'test'
    end
    user.save
  end
  let(:account) { Account.create(:name => 'Wallet', :user_id => user.id) }
  let(:budget) do
    Budget.create do |b|
      b.name = 'Budget'
      b.spending_limit = 100
      b.user_id = user.id
    end
  end

  let!(:clothes) do
    Tag.create(:name => 'Clothes', :user_id => user.id)
  end
  let!(:hardware) do
    Tag.create(:name => 'Hardware', :user_id => user.id)
  end
  let!(:gardening) do
    Tag.create(:name => 'Gardening', :user_id => user.id)
  end

  let!(:shopping) do
    shopping = Budget.create do |b|
      b.name = "Shopping"
      b.spending_limit = 200
      b.user_id = user.id
    end
    shopping.add_tag(gardening)
    shopping.add_tag(clothes)
    shopping
  end
  
  let!(:transactions) do
    one = Transaction.create do |t|
      t.date = 'Oct 16 2015'
      t.amount = 100
      t.type = 'income'
      t.description = 'Income'
      t.account_id = account.id
      t.user_id =  user.id
    end
    one.add_tag(clothes)
    one
    two = Transaction.create do |t|
      t.date = 'Mar 26 2016'
      t.amount = 100
      t.type = 'income'
      t.description = 'Income'
      t.account_id = account.id
      t.user_id =  user.id
    end
    two.add_tag(hardware)
    two
    three = Transaction.create do |t|
      t.date = 'Mar 6 2016'
      t.amount = 10.89
      t.type = 'expense'
      t.description = 'Chocolate Moose'
      t.account_id = account.id
      t.user_id =  user.id
    end
    three.add_tag(hardware)
    three
    four = Transaction.create do |t|
      t.date = 'Mar 26 2015'
      t.amount = 25.23
      t.type = 'expense'
      t.description = 'Polygon'
      t.account_id = account.id
      t.user_id =  user.id
    end
    four.add_tag(gardening)
    four
  end

  context 'when associations are correct' do
    it 'belongs to a user' do
      expect(budget.user.class).to eq User
    end

    it 'has tags' do
      expect(budget.tags).to eq []
    end
  end

  describe '#balance' do
  end
  
  describe '#total' do
    context "when budgets belonging to a user are summed" do
		  it "sums all budget spending limits" do
		    expect(Budget.total(user.id)).to eq 200
		  end
		end
		
		context "when a budget is summed belonging to a user" do
		  it 'sums the specified budget' do
		    expect(Budget.total(user.id, shopping.name)).to eq 200
		  end
		end
  end
end
