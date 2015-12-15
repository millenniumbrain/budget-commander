BudgetCommander.route('v1', 'tags') do |r|
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      tags = DB[:tags].join(:transactions).all.to_json
    end
  end
end
