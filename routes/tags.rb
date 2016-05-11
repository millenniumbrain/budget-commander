BudgetCommander.route('tags') do |r|
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      tags = DB[:tags].all.to_json
    end
  end
end
