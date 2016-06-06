BudgetCommander.route('totals') do |r|
  @user = User[1]
  @income = Transaction.current_month_income(@user.id)
  @expense = Transaction.current_month_expense(@user.id)
  @networth = Transaction.total(@user.id)
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      { :networth => format("%.2f", @networth),
        :budget_balance => format("%.2f", Budget.balance(@user.id)[:budget_balance]),
        :income => format("%.2f", @income[:income][:amount]),
        :expense => format("%.2f", @expense[:expense][:amount])
      }.to_json
    end
  end

  r.is 'income' do
    r.get do
      response['Content-Type'] = 'application/json'
      query_params = parse_nested_query(r.query_string)
      if query_params["monthly"]
        Transaction.total_income_by_month(@user.id).to_json
      else
        @income.to_json
      end
    end
  end

  r.is 'expense' do
    r.get do
      query_params = parse_nested_query(r.query_string)
      response['Content-Type'] = 'application/json'
      if query_params["monthly"]
        Transaction.total_expense_by_month(@user.id).to_json
      else
        @expense.to_json
      end
    end
  end

  r.is 'networth' do
    r.get do
      response['Content-Type'] = 'application/json'
      @expense.to_json
    end
  end

  r.is 'budgets' do
    r.get do
      response['Content-Type'] = 'application/json'
      budgets = @user.budgets_dataset.where('user_id = ?',@user.id)
      .to_json(:include => :tags_data, :only => [:_id, :name, :spending_limit])
      budgets = JSON.parse(budgets)
      budgets.each { |b| b["spending_limit"] = format("%.2f", b["spending_limit"])}
      budgets.to_json
    end
  end
end
