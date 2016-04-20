BudgetCommander.route('api') do |r|
  r.is do
    r.get do
      "Works"
    end
  end
    
  r.multi_route('api')
end