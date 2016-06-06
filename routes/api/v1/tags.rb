BudgetCommander.route('tags', 'v1') do |r|
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      tags = Tag.select(:_id, :name).all.to_json(:only => [:name, :_id])
    end
  end
end
