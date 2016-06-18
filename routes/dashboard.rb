BudgetCommander.route('dashboard') do |r|
  r.is do
    r.get do
      @public_key = OpenSSL::PKey::RSA.new(session[:public_key]).public_key
      decode_token = JWT.decode(session[:encoded_token], @public_key, true, { :algorithm => 'RS256' })
      pp decode_token
      @title = "Home"
      view 'dashboard/dashboard', layout: 'dashboard/layout'
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
