BudgetCommander.route('totals') do |r|
  @user = User[1]
  @income = Transaction.current_month_income(@user.id)
  @expense = Transaction.current_month_expense(@user.id)
  @networth = Transaction.total(@user.id)
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      { :networth => format("%.2f", @networth),
        :income => @income,
        :expense => @expense
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
end
