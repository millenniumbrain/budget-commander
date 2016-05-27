BudgetCommander.route('accounts') do |r|
  @current_user = User[1]
  r.is ':id' do |id|
    r.get do
      response['Content-Type'] = 'application/json'
      Account[id].to_json(:only => :name)
    end
  end

  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      @current_user.accounts_dataset.select(:name).all.to_json
    end

    r.post do
      account = parse_json_inputs.inject({}) do |hash, item|
        hash[item["name"]] = item["value"]
        hash
      end
      begin
        new_account = Account.new do |a|
          a.name = account["account_name"]
        end
        @current_user.add_account(new_account)
                response.status = 200
        {:status => "ok", :msg => "Account created successfully"}.to_json
      rescue ArgumentError => e
        response.status = 500
        {:status => "error", :msg => "Transaction failed #{e}"}.to_json
      rescue Sequel:: Error => e
        response.status = 500
        {:status => "error", :msg => "Transaction failed #{e}"}.to_json
      end
      new_account.save
      response.status = 200
    end
  end
end
