BudgetCommander.route('transactions', 'users') do |r|
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      transactions = Transaction.all.to_json(:include => :account)
      parsed_transactions = JSON.parse(transactions)
      parsed_transactions.map do |t|
        t["account_id"] = account_name(t["account_id"])
        t["date"] = Time.parse(t["date"]).utc.strftime("%b %e")
      end
      parsed_transactions.to_json
    end

    r.post do
      transaction = parse_json_inputs.inject({}) do |hash, item|
        hash[item["name"]] = item["value"]
        hash
      end
      if transaction["TransactionType"] == "expense"
        transaction["TransactionAmount"] = -transaction["TransactionAmount"].to_f
      else

      end
      account = Account.first(:name => transaction["TransactionAccount"])
      new_transaction = Transaction.new do |t|
        t.amount = transaction["TransactionAmount"].to_f
        t.description = transaction["TransactionDescription"]
        t.date = DateTime.strptime(transaction["TransactionDate"], '%b %d %Y')
      end
      pp new_transaction.amount
      account.add_transaction(new_transaction)
    end
  end
end
