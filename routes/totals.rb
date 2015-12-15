BudgetCommander.route('totals') do |r|
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
