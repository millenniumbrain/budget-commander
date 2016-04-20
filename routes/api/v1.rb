BudgetCommander.route('v1', 'api') do |r|
  r.is do
    r.is do
      r.get do
        "It works"
      end
    end
  end
  r.multi_route('v1')
end