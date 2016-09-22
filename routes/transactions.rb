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
        account = Account.where(:name => transaction["transaction_account"]).first
      end
      tags = []
      unless transaction["transaction_tags"].empty? || transaction["transaction_tags"].nil?
        # split tag array

        transactions_tags = transaction["transaction_tags"].delete(' ').split(',')
        transactions_tags.each do |t|
          case Tag.where(:name => t).count
          when 0
            # if no tags are found create tag and add to user
            @tag = Tag.new(:name => t)
            @current_user.add_tag(@tag)
            # add to tags to be used by the transaciton
            tags.push(@tag)
          when 1
            # if transaction exists add find it and add it to tags
            tags.push(Tag.where(:name => t).first)
          else
          end

        end
      end
      # create a new transaction and add it to the logged in user
      begin
        new_transaction = Transaction.new do |t|
          t.amount = transaction["transaction_amount"].to_f
          t.description = transaction["transaction_description"]
          t.type = transaction["transaction_type"]
          t.date = DateTime.strptime(transaction["transaction_date"], '%b %d %Y')
          t.account_id = account.id
        end
        @current_user.add_transaction(new_transaction)
        unless tags.length == 0
          tags.each do |t|
            new_transaction.add_tag(t)
          end
        end
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
      transaction = JSON.parse(transaction)
      transaction['date'] = Date.parse(transaction['date']).strftime('%b %d %Y')
      transaction['account_id'] = Account.where(id: transaction['account_id']).first.name
      transaction.to_json
    end

    r.put do
      response['Accept'] = 'application/json'
      response['Content-Type'] = 'application/json'
      updated_transaction = JSON.parse(env['rack.input'].gets)
      updated_transaction = updated_transaction.each_with_object({}) do |item, hash|
        hash[item["name"]] = item["value"]
        hash
      end
      transaction = Transaction.select(:id, :amount, :description, :date, :amount, :type, :description, :account_id)
      .where(:uid => id).first
      account = Account.select(:name, :id).filter(:name => updated_transaction["transaction_account"]).first
      unless transaction.account_id == account.id
        transaction.account_id = account.id
      end
      # Create two array current tags and new tags if it exists in the database add to current tags using
      # if it does not yet exist in the database add tags to new tags array
      current_tags = []
      new_tags = []
      updated_transaction["transaction_tags"].split(',').each do |t|
        if Tag.where(:name => t).count == 1
          current_tags.push(Tag.select(:id, :uid, :name, :user_id).where(:name => t).first)
        else
          new_tags.push(Tag.new(:name => t, :user_id => @current_user.id))
        end
      end
      # just add tags if no tags exist
      if transaction.tags.empty?
        i = 0
        while i < current_tags.length
          transaction.add_tag(current_tags[i])
          i += 1
        end
      else
        # compare the client array with the transaction array
        # if tag doesn't exist in the transaction add to transaction
        # else remove tag from transaction
        current_tags.each do |tag|
          pp tag
          if !transaction.tags.include? tag
            transaction.add_tag(tag)
          end
        end
        transaction.tags.each do |tag|
          if !current_tags.include? tag
            transaction.remove_tag(tag)
          end
        end
      end
      i = 0
      while i < new_tags.length
        new_tags[i].save
        transaction.add_tag(new_tags[i])
        i += 1
      end
      transaction.amount = updated_transaction["transaction_amount"].to_f
      transaction.description = updated_transaction["transaction_description"]
      transaction.type = updated_transaction["transaction_type"]
      transaction.date = DateTime.strptime(updated_transaction["transaction_date"], '%b %d %Y')
      transaction.account_id = account.id
      if transaction.modified?
        transaction.save_changes
      end
    end

    r.delete do
      Transaction.where(:uid => id).first.delete
    end
  end
end
