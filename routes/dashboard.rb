BudgetCommander.route('dashboard') do |r|
  r.is do
    r.get do
      view 'dashboard/dashboard', layout: 'dashboard/layout'
    end
  end
end
