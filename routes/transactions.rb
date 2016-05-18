BudgetCommander.route('transactions') do |r|
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      query_params = parse_nested_query(r.query_string)
      user = User[1]
      transactions = user.transactions_dataset
        .order(Sequel.desc(:transactions__id))
        .limit(10)
        .to_json(:include => :tag_data,:only => [:date,
        :amount, :type, :description, :account_id, :updated_at])
        transactions = JSON.parse(transactions)
        transactions.each do |t|
          t["date"] = Date.parse(t["date"]).strftime('%b %d %Y')
          t["account_id"] = account_name(t["account_id"])
        end
        #r.etag(transactions.length)
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
          t.account_id = account.first["id"]
          t.user_id = 1
        end
        if new_transaction.save
          response.status = 200
        else
          raise Sequel::Rollback
          response.status = 503
        end
      end
    end

    r.is 'count' do
      r.get do
        response['Content-Type'] = 'application/json'
        DB[:transactions].count.to_json
      end
    end

    r.is ':id' do |id|
      r.get do
        response['Content-Type'] = 'application/json'
        transaction = JSON.parse(Transaction[id].to_json)
        transaction["date"] = transaction["date"].to_s.tr('-:. UTC', '')
        transaction["account_id"] = account_name(transaction["account_id"])
        transaction.to_json
      end
    end
  end
