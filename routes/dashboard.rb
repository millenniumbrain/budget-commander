BudgetCommander.route('dashboard') do |r|
  r.is do
    r.get do
      decoded_token = JWT.decode(session[:encoded_token], ENV['HMAC-SECRET'], true, { algorithm: 'HS256' })
      @title = 'Home'
      if session[:logged_in]
        view 'dashboard/dashboard', layout: 'dashboard/layout'
      else
        r.redirect '/login'
      end
    end

    r.post do

    end
  end

  r.is 'groups' do
    r.get do
      view 'dashboard/groups', layout: 'dashboard/layout'
    end
  end

  r.is 'receipts' do
    r.get do
      view 'dashboard/receipts', layout: 'dashboard/layout'
    end
  end
end
