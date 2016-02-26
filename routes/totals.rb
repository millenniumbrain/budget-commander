BudgetCommander.route('totals') do |r|
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      expenses = Total::Expense.new
      income = Total::Income.new
      total_expenses = Transaction.where('type = ?', 'expense').sum(:amount).round(2)
      total_income = Transaction.where('type = ?', 'income').sum(:amount).round(2)
      {:networth => total_income - total_expenses,
        :budget_balance => 0,
        :income => income.current_month,
        :expense => expenses.current_month}.to_json
      end
    end

    r.is 'income' do
      r.get do
        response['Content-Type'] = 'application/json'
        income = Total::Income.new
        income.by_month
      end
    end

    r.is 'expenses' do
      r.get do
        response['Content-Type'] = 'application/json'
        expnses = Total::Expenses.new
        expenses.by_month
      end
    end

    r.is 'budgets' do
      r.get do
        response['Content-Type'] = 'application/json'
        Budget.all.to_json
      end
    end
end
