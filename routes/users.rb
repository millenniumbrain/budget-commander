BudgetCommander.route('users') do |r|
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

  r.on 'total' do
    r.is do
      r.get do
        response['Content-Type'] = 'application/json'
        {:networth => Transaction.sum(:amount),
         :budget_balance => DB[:budgets].sum(:spending_limit) + Total::Expenses.new.monthly,
         :income => Total::Income.new.monthly,
         :expenses => Total::Expenses.new.monthly}.to_json
      end
    end

    r.is 'income' do
      r.get do
        response['Content-Type'] = 'application/json'
        Transaction.income.to_json
      end
    end

    r.is 'expenses' do
      response['Content-Type'] = 'application/json'
      Transaction.expenses.to_json
    end
  end


  r.is do
    r.get do
      view 'users/dashboard', layout: 'layout'
    end
  end
  r.multi_route('users')
end
