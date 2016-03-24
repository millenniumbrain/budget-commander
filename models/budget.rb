class Budget < Sequel::Model(:budgets)
  plugin :json_serializer
  many_to_one :user
  many_to_many :tags

  def self.current_month_balance(u_id, budget_name = nil, tag_name = nil)
    return unless u_id
    if budget_name.nil? && tag_name.nil?
      budget_balance = select(:spending_limit)
        .where('type = ?', u_id)
.sum(:spending_limit)
			month_total = Transaction.current_month_total('expense', u_id)
			budget_balance - month_total
    elsif tag_name.nil?
      budget_balance = select(:spending_limit)
        .where{(name =~ budget_name.downcase) & (user_id =~ u_id)}
        .sum(:spending_limit)
    else
      #budget_balance = 
    end
  end
end
