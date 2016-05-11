require 'rspec/expectations'
require 'rspec/core'

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
