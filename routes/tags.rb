BudgetCommander.route('tags') do |r|
  @user = User[1]
  r.is do
    r.get do
      response['Content-Type'] = 'application/json'
      Tag.where(:user_id => @user.id).to_json(only: [:_id, :name])
    end

    r.post do

    end
  end
end
