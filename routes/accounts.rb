BudgetCommander.route('accounts') do |r|
  r.on 'all' do
    r.is ':id' do |id|
      r.get do
        response['Content-Type'] = 'application/json'
        Account[id].to_json(:only => :name)
      end
    end
  end
end
