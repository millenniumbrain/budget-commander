BudgetCommander.route('transactions', 'users') do |r|
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      transaction_promise = Concurrent::Promise.new do
        DB[:transactions].select(:description, :account_id, :amount, :date)
          .limit(10).all
      end.then do |result|
        transaction = result.each do |t|
          t["account_id"] = account_name(t["account_id"])
        end
      end.execute
      pp transaction_promise.value
    end

    r.post do
      transaction = parse_json_inputs.inject({}) do |hash, item|
        hash[item["name"]] = item["value"]
        hash
      end
      pp transaction
      if transaction["type"] == "expense"
        transaction["amount"] = -transaction["amount"].to_f
      else

      end
      account = Account.first(:name => transaction["account"])
      new_transaction = Transaction.new do |t|
        t.amount = transaction["amount"].to_f
        t.description = transaction["description"]
        t.date = DateTime.strptime(transaction["date"], '%b %d %Y')
      end
      pp new_transaction.amount
      account.add_transaction(new_transaction)
    end
  end
end
