BudgetCommander.route('totals') do |r|
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      {:networth => Transaction.total,
        :budget_balance => 0,
        :income => Transaction.current_month_total('income'),
        :expense => Transaction.current_month_total('expense')}.to_json
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

    r.is 'budgets' do
      r.get do
        response['Content-Type'] = 'application/json'
        Budget.all.to_json
      end
    end
end
