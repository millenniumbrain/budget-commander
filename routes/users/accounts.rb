BudgetCommander.route('accounts', 'users') do |r|

  r.is 'new' do
    r.get do
      view 'users/accounts/new', layout: 'layout'
    end

    r.post do

    end
  end

  r.is 'delete' do
    r.get do

    end

    r.post do

    end
  end

  r.on 'all' do
    r.is ':id' do |id|
      r.get do
        response['Content-Type'] = 'application/json'
        Account[id].to_json(:only => :name)
      end
    end
  end
  
  r.on 'transactions' do
    r.is 'new' do
      r.get do
        acct = Account[1]
        acct.add_transaction(amount: 75, description: 'Notebook', :created_at => TimeShift.sub_months(1))
      end
    end
    
    r.is do
      r.get do
        response['Content-Type'] = 'application/json'
        transactions = Transaction.all.to_json(:include => :account)
        parsed_transactions = JSON.parse(transactions)
        parsed_transactions.map do |t|
          t["account_id"] = account_name(t["account_id"])
          t["created_at"] = Time.parse(t["created_at"]).utc.strftime("%b %e")
          t["updated_at"] = Time.parse(t["updated_at"]).utc.strftime("%b %e")
        end
        parsed_transactions.to_json
      end
    end
  end
end
