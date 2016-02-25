BudgetCommander.route('transactions') do |r|
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      transaction = DB[:transactions].
      select(:date, :amount, :description, :account_id, :type)
      .limit(10).all
      transaction.each do |t|
        t[:date] = t[:date].to_s.tr('-:. UTC', '')
        t[:account_id] = account_name(t[:account_id])
      end
      transaction.to_json
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
      account.add_transaction(new_transaction)
    end
  end
end
