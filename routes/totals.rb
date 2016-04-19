BudgetCommander.route('totals'.freeze) do |r|
  @user = User[1]
  @income = Transaction.current_month_income(@user.id)
  @expense = Transaction.current_month_expense(@user.id)
  @networth = Transaction.total(@user.id)
  r.is do
    r.get do
      r.last_modified(DateTime.parse(@income[:income][:updated_at].to_s).to_time)
      r.last_modified(DateTime.parse(@expense[:expense][:updated_at].to_s).to_time)
      response['Content-Type'.freeze] = 'application/json'.freeze
      { :networth => @networth,
        :budget_balance => Budget.balance(@user.id)[:budget_balance],
        :income => @income[:income][:amount],
        :expense => @expense[:expense][:amount]
      }.to_json
    end
  end

  r.is 'income' do
    r.get do
      response['Content-Type'] = 'application/json'
      @income.to_json
    end
  end

  r.is 'expense' do
    r.get do
      response['Content-Type'] = 'application/json'
      @expense.to_json
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
      Budget.where('user_id = ?',@user.id).to_json
    end
  end
end
