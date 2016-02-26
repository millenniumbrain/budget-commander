BudgetCommander.route('accounts') do |r|
  r.is ':id' do |id|
    r.get do
      response['Content-Type'] = 'application/json'
      Account[id].to_json(:only => :name)
    end
  end

  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      Account.select(:id, :name, :user_id).all.to_json
    end

    r.post do

    end
  end
end
