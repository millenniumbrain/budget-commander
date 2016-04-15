BudgetCommander.route('dashboard'.freeze) do |r|
  r.is do
    r.get do
      view 'dashboard/dashboard'.freeze, layout: 'dashboard/layout'.freeze
    end
  end
  
  r.is 'groups' do
    r.get do
      view 'dashboard/groups'.freeze, layout: 'dashboard/layout'.freeze
    end
  end
end
