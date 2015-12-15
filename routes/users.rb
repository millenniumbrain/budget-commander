BudgetCommander.route('users') do |r|

  # @resource /budgets [/budgets]
  #  contains all operations related to budgets
  r.on 'budgets' do
    r.is do
      r.get do
        response['Content-Type'] = 'application/json'
        Budget.all.to_json
      end
    end

    r.is 'new' do
      r.get do
        user = User[1]
        user.add_budget(:name => "Hoes", :spending_limit => 300)
      end
    end
  end

  r.is 'tags' do
    r.get do
      response['Content-Type'] = 'application/json'
      tags = DB[:tags].join(:transactions).all.to_json
    end
  end




  r.is do
    r.get do
      view 'users/dashboard', layout: 'layout'
    end
  end
  r.multi_route('users')
end
