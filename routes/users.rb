BudgetCommander.route('users') do |r|
  r.is do
    r.get do
      view 'users/dashboard', layout: 'layout'
    end
  end
  r.multi_route('users')
end
