BudgetCommander.route('accounts') do |r|
  r.is ':id' do |id|
    r.get do
      response['Content-Type'] = 'application/json'
      Account[id].to_json(:only => :name)
    end
  end

  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      Account.select(:id, :name, :user_id).all.to_json
    end

    r.post do
      account = parse_json_inputs.inject({}) do |hash, item|
        hash[item["name"]] = item["value"]
        hash
      end
      new_account = Account.new do |a|
        a.name = account["account_name"]
        a.user_id = 1
      end
      new_account.save
      response.status = 200
    end
  end
end
