BudgetCommander.route('login') do |r|
  r.is do
    r.get do
      @title = "Login"
      view 'users/login', :layout => 'users/layout'
    end

    r.post do
      user = JSON.parse(env['rack.input'].gets)
      user = user.inject({}) do |hash, item|
        hash[item["name"]] = item["value"]
        hash
      end
      logged_in = User.login(user["email"], user["password"])
      if logged_in
        payload = {
          :aud => ["Browser", "User"],
          :email => user["email"]
        }
        rsa_private_key = OpenSSL::PKey::RSA.generate 2048
        rsa_public_key = rsa_private_key.public_key
        session[:public_key] = rsa_public_key.to_s
        session[:encoded_token] = JWT.encode(payload, rsa_private_key, 'RS256')
        response.status = 200
        {:status => "ok", :msg => "#{user["email"]} has logged in."}
      else
        response.status = 404
        {:status => "404", :msg => "User not Found"}.to_json
      end
    end
  end
end
