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
        .limit(10)
        .to_json(:include => :tag_data,:only => [:date,
          :amount, :type, :description, :account_id, :updated_at])
          transactions = JSON.parse(transactions)
          transactions.each do |t|
            t["date"] = Date.parse(t["date"]).strftime('%b %d %Y')
            t["account_id"] = account_name(t["account_id"])
          end
          r.etag(transactions.length)
          transactions.to_json
        end
      end

      r.post do
        response['Content-Type'] = 'application/json'
        transaction = parse_json_inputs.inject({}) do |hash, item|
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
