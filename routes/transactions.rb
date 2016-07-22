# /api/v1/transactions
BudgetCommander.route('transactions') do |r|
  @current_user = User[1]
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      query_params = parse_nested_query(r.query_string)
      user = User[1]
      if query_params['count']
        transactions_length = user.transactions_dataset.count
        transactions_length.to_json
      else
        transactions = Transaction.filter(user_id: @current_user.id)
                           .order(Sequel.desc(:transactions__id))
                           .limit(25)
                           .to_json(:include => :tags_data, only: [:uid,
                                                                   :date,
                                                                   :amount,
                                                                   :type,
                                                                   :description,
                                                                   :account_id])
        transactions = JSON.parse(transactions)
        transactions.each do |t|
          # TODO: Add option for DD MM YYYY
          t['date'] = Date.parse(t['date']).strftime('%b %d %Y')
          t['account_id'] = Account.where(id: t['account_id']).first.name
          t['amount'] = format('%.2f', t['amount'])
        end
        transactions.to_json
      end
    end

    r.post do
      response['Accept'] = 'application/json'
      response['Content-Type'] = 'application/json'
      transaction = JSON.parse(env['rack.input'].gets)
      transaction = transaction.each_with_object({}) do |item, hash|
        hash[item["name"]] = item["value"]
        hash
      end
      unless transaction["transaction_account"].empty?
        account = Account.where(:name => transaction["transaction_account"]).to_json
        account = JSON.parse(account)
      end
      unless transaction["transaction_tags"].empty?
        tags = transactions["transaction_tags"].split(',')
        tags.each do |t|
          unless Tag.where(:name => t).count == 1
            @tag = Tag.new(:name => t)
          end
        end
      end
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
        { status: "ok", msg: 'Transaction added successfull'}.to_json
      rescue ArgumentError => e
        response.status = 500
        { status: "500", msg: "Transaction failed #{e}"}.to_json
      rescue Sequel::Error => e
        response.status = 500
        { status: "500", msg: "Transaction failed #{e}"}.to_json
      end
    end
  end

  r.is ':id' do |id|
    r.get do
      response['Content-Type'] = 'application/json'
      transaction = Transaction.where.(:uid => id).first
        .to_json(:include => :tags_data, only: [:uid, :date, :amount, :type, :description, :account_id])
      pp transaction = JSON.parse(transaction)
      transaction['date'] = Date.parse(transaction['date']).strftime('%b %d %Y')
      transaction['account_id'] = Account.where(id: transaction['account_id']).first.name
      transaction.to_json
    end

    r.put do
    end
  end
end
