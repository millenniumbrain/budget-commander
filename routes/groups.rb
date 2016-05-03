BudgetCommander.route('groups') do |r|
  r.is do
    r.get do
      view 'dashboard/groups', layout: 'dashboard/layout'
    end
  end
end