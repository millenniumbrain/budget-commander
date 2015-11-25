BudgetCommander.route('accounts', 'users') do |r|

  r.is 'new' do
    r.get do
      view 'users/accounts/new', layout: 'layout'
    end

    r.post do

    end
  end

  r.is 'delete' do
    r.get do

    end

    r.post do

    end
  end

  r.on 'all' do
    r.is ':id' do |id|
      r.get do
        response['Content-Type'] = 'application/json'
        Account[id].to_json(:only => :name)
      end
    end
  end
end
