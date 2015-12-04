BudgetCommander.route('transactions', 'users') do |r|
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      transaction = Concurrent::Promise.new do
        DB[:transactions].select(:date, :amount, :description, :account_id, :type)
          .limit(10).all
      end.then do |result|
        result.each do |t|
          t[:date] = t[:date].utc.strftime("%b %e")
          t[:account_id] = account_name(t[:account_id])
        end
      end.execute
      transaction.value.to_json
    end

    r.post do
      transaction = parse_json_inputs.inject({}) do |hash, item|
        hash[item["name"]] = item["value"]
        hash
      end
      account = Account.first(:name => transaction["account"])
      new_transaction = Transaction.new do |t|
        t.amount = transaction["amount"].to_f
        t.description = transaction["description"]
        t.type = transaction["type"]
        t.date = DateTime.strptime(transaction["date"], '%b %d %Y')
      end
      pp account.add_transaction(new_transaction)
    end
  end
end
