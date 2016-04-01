class Budget < Sequel::Model(:budgets)
  plugin :json_serializer
  many_to_one :user
  many_to_many :tags

  # Calculating budget balances
  #------
  # Retrive all expense transactions with the same tag as the budget with
  # the budget table working as a psuedo category table.
  def self.balance(u_id, budget_name = '')
    if budget_name != ''
      total_expense = 0
      self[:name => budget_name].tags.each do |t|
        total = Transaction.select(:amount).where(:tags => t)
        .and(:type => 'expense')
        .and(:user_id => u_id)
        .sum(:amount)
        unless total.nil?
          total_expense = total_expense + total
        end
      end
      budget = self[:name => budget_name][:spending_limit] 
      {budget_name => budget - total_expense}
    else
      total_expense = 0
      self.all.each do |k,v|
        k.tags.each do |t|        
          total = Transaction.select(:amount).where(:tags => t)
            .and(Sequel.extract(:month, :date) => Date.today.month)
            .and(:type => 'expense')
            .and(:user_id => u_id)
            .sum(:amount)   
          unless total.nil?
            total_expense = (total_expense + total).round(2)
          end
        end
      end
      budget = self.sum(:spending_limit)
      {"budget_balance" => (budget - total_expense).round(2)}
    end
  end
  
  # Asking for the total spending limit
  #------
  def self.total?(u_id, budget_name = nil)
    return unless u_id
    if budget_name.nil?
      budget_total = select(:spending_limit)
        .where('user_id = ?', u_id)
        .sum(:spending_limit)
    else
      budget_total = select(:spending_limit)
        .where{(user_id =~ u_id) & (name =~ budget_name)}
        .sum(:spending_limit)
    end
  end
  
  def tag_names
    self.tags.map(&:names)
  end
end
