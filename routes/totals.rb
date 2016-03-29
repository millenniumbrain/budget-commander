BudgetCommander.route('totals') do |r|
  r.is do
    r.get do
      user = User[1]
      response['Content-Type'] = 'application/json'
      { :networth => Transaction.total(user.id),
        :budget_balance => Budget.balance(user.id)["budget_balance"],
        :income => Transaction.current_month_total(user.id)["income"],
        :expense => Transaction.current_month_total(user.id)["expense"]
      }.to_json
    end
  end

  r.is 'income' do
    r.get do
      response['Content-Type'] = 'application/json'
      {:income => Transaction.current_month_total('income')}.to_json
    end
  end

  r.is 'expense' do
    r.get do
      response['Content-Type'] = 'application/json'
      {:expense => Transaction.current_month_total('expense')}.to_json
    end
  end
  
  r.is 'networth' do
    r.get do
      response['Content-Type'] = 'application/json'
    end
  end

  r.is 'budgets' do
    r.get do
      response['Content-Type'] = 'application/json'
      user = User[1]
      Budget.where('user_id = ?', user.id).to_json
    end
  end
end
