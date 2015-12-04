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
        expenses = Total::Expenses.new
        income = Total::Income.new
        {:networth => Transaction.sum(:amount).round(2),
         :budget_balance => DB[:budgets].sum(:spending_limit),
         :income => income.async.annual.value,
         :expenses => expenses.async.annual.value}.to_json
      end
    end

    r.is 'income' do
      r.get do
        response['Content-Type'] = 'application/json'
        income = Total::Income.new
        income.async.by_month.value
      end
    end

    r.is 'expenses' do
      r.get do
        response['Content-Type'] = 'application/json'
        expnses = Total::Expenses.new
        expenses.async.by_month.value
      end
    end
  end


  r.is do
    r.get do
      view 'users/dashboard', layout: 'layout'
    end
  end
  r.multi_route('users')
end
