BudgetCommander.route('dashboard'.freeze) do |r|
  r.is do
    r.get do
      view 'dashboard/dashboard'.freeze, layout: 'dashboard/layout'.freeze
    end
  end
end
