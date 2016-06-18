BudgetCommander.route('transactions') do |r|
  @current_user = User[1]
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      query_params = parse_nested_query(r.query_string)
      user = User[1]
      if query_params["count"]
        transactions_length = user.transactions_dataset.count
        transactions_length.to_json
      else
        transactions = user.transactions_dataset
        .order(Sequel.desc(:transactions__id))
        .limit(25)
        .to_json(:include => :tags_data, :only => [:date,
          :amount, :type, :description, :account_id, :_id])
        transactions = JSON.parse(transactions)
        transactions.each do |t|
            # TODO: Add option for DD/MM/YYYY
            t["date"] = Date.parse(t["date"]).strftime('%b %d %Y')
            t["account_id"] = Account.where(:id => t["account_id"]).first.name
            t["amount"] = format("%.2f", t["amount"])
        end
          transactions.to_json

      end
    end

    r.post do
      response['Accept'] = 'application/json'
      response['Content-Type'] = 'application/json'
      transaction = JSON.parse(env['rack.input'].gets)
      transaction = transaction.inject({}) do |hash, item|
        hash[item["name"]] = item["value"]
        hash
      end
      account = Account.where(:name => transaction["transaction_account"]).to_json
      account = JSON.parse(account)
      begin
        new_transaction = Transaction.new do |t|
          t.amount = transaction["transaction_amount"].to_f
          t.description = transaction["transaction_description"]
          t.type = transaction["transaction_type"]
          t.date = DateTime.strptime(transaction["transaction_date"], '%b %d %Y')
          t.account_id = account.first["id"]
        end
        @current_user.add_transaction(new_transaction)
        response.status = 200
        {:status => "ok", :msg => "Transaction added successfully"}.to_json
      rescue ArgumentError => e
        response.status = 500
        {:status => "error", :msg => "Transaction failed #{e}"}.to_json
      rescue Sequel::Error => e
        response.status = 500
        {:status => "error", :msg => "Transaction failed #{e}"}.to_json
      end
    end
  end

  r.is 'count' do
    r.get do
      response['Content-Type'] = 'application/json'
      self.count.to_json
    end
  end

  r.is ':id' do |id|
    r.get do
      response['Content-Type'] = 'application/json'
      transaction = JSON.parse(Transaction.where(:_id => id))
      transaction["date"] = transaction["date"].to_s.tr('-:. UTC', '')
      transaction["account_id"] = account_name(transaction["account_id"])
      transaction.to_json
    end
  end
end
