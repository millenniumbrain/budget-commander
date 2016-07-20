BudgetCommander.route('login') do |r|
  r.is do
    r.get do
      @title = "Login"
      view 'users/login', :layout => 'users/layout'
    end

    r.post do
      user = JSON.parse(env['rack.input'].gets)
      user = user.each_with_object({}) do |item, hash|
        hash[item["name"]] = item["value"]
      end
      logged_in = User.login(user["email"], user["password"])
      if logged_in
        payload = {
          aud: ["Browser", "User"],
          email: user["email"]
        }
        response.encode_payload(payload)
        session[:encoded_token] = response.token
        session[:logged_in] = true
        response.status = 200
        { status: 'ok', msg: "#{user["email"]} has logged in."}
      else
        response.status = 404
        { status: '404', msg: "#{user} not Found" }.to_json
      end
    end
  end
end
