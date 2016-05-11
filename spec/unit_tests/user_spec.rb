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
