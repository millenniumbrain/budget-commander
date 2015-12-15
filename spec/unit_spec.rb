require './models'
require './spec/spec_helper'

describe Account do
  before(:all) do
    @user = User.create(:email => 'test@test.com', :name => 'tests', :password => 'test')
    @checking = Account.create(:name => 'Checking', :user_id => @user.id)
  end

  before do
    @user = User.call(@user.values.dup)
    @checking = Account.call(@checking.values.dup)
  end

  it 'associations should be correct' do
    @checking.user.class.must_equal User
    @checking.transactions.must_equal []
  end
end

describe User do
  before (:all) do
    @user = User.create(:email => 'test@test.com', :name => 'tests', :password => 'test')
  end

  before do
    @user = User.call(@user.values.dup)
  end

  it 'associations should be correct' do
    @user.accounts.must_equal []
    @user.transactions.must_equal []
    @user.budgets.must_equal []
    @user.tags.must_equal []
  end
end
