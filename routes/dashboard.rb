BudgetCommander.route('dashboard') do |r|
  r.is do
    r.get do
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
