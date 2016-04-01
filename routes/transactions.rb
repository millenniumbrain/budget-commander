BudgetCommander.route('transactions') do |r|
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      user = User[1]
      transactions = Transaction
      .where(:user_id => user.id)
      .order(Sequel.desc(:transactions__id))
      .limit(10)
      .to_json(:include => :tag_names,:only => [:date, 
      :amount, :type, :description, :account_id, :updated_at])
      transactions = JSON.parse(transactions)
      for i in 0..transactions.length do
        transactions[i]["date"] = transactions[i]["date"].to_s.tr('-:. UTC', '')
        transactions[i]["account_id"] = account_name(transactions[i]["account_id"])
        r.last_modified(DateTime.parse(transactions[i]["updated_at"]).to_time)
      end
      transactions.to_json
    end

    r.post do
      transaction = parse_json_inputs.inject({}) do |hash, item|
        hash[item["name"]] = item["value"]
        hash
      end
      account = Account.where(:name => transaction["transaction_account"]).to_json
      account = JSON.parse(account)
      new_transaction = Transaction.new do |t|
        t.amount = transaction["transaction_amount"].to_f
        t.description = transaction["transaction_description"]
        t.type = transaction["transaction_type"]
        t.date = DateTime.strptime(transaction["transaction_date"], '%b %d %Y')
        t.account_id = account[0]["id"]
        t.user_id = 1
      end
      new_transaction.save
      response.status = 200
    end
  end

  r.is 'count' do
    r.get do
      response['Content-Type'] = 'application/json'
      DB[:transactions].count.to_json
    end
  end

  r.on 'all' do
    r.is ':id' do |id|
      r.get do
        response['Content-Type'] = 'application/json'
        transaction = JSON.parse(Transaction[id].to_json)
        transaction["date"] = transaction["date"].to_s.tr('-:. UTC', '')
        transaction["account_id"] = account_name(transaction["account_id"])
        transaction.to_json
      end
    end

    r.is do

    end
  end
end
