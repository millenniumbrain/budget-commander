BudgetCommander.route('transactions') do |r|
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      transaction = DB[:transactions].
      select(:date, :amount, :description, :account_id, :type)
      .order(Sequel.desc(:id))
      .limit(10)
      .all
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
      transaction
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
