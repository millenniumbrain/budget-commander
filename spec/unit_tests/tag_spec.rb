require 'rspec/expectations'
require 'rspec/core'

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
