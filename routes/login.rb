BudgetCommander.route('login') do |r|
  r.is do
    r.get do
      @title = "Login"
      view 'users/login', :layout => 'users/layout'
    end

    r.post do
      response['Accept'] = 'application/json;charset=utf-8'
      response['Content-Type'] = 'application/json;charset=utf-8'
      user = JSON.parse(env['rack.input'].gets)
      user = user.each_with_object({}) do |item, hash|
        hash[item["name"]] = item["value"]
      end
      logged_in = User.login(user["email"], user["password"])
      begin
        if logged_in
          payload = {
            aud: ["Browser", "User"],
            email: user["email"]
          }
          response.encode_payload(payload)
          session[:encoded_token] = response.token
          session[:logged_in] = true
          response.status = 200
          { status: 'ok', msg: "Login successful!"}
        else
          response.status = 404
          { status: '404', msg: "User does not exist" }.to_json
        end
      rescue => e
        response.status = 500
        {status: '500', msg: "#{e.message}"}.to_json
      end
    end
  end
end
