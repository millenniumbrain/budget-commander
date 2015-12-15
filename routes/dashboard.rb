BudgetCommander.route('dashboard') do |r|
  r.is do
    r.get do
      view 'users/dashboard', layout: 'layout'
    end
  end
end
