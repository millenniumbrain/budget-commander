class Budget < Sequel::Model(:budgets)
  plugin :json_serializer
  many_to_one :user
  many_to_one :group
  many_to_many :tags

  # Calculating budget balances
  # Retrive all expense transactions with the same tag as the budget with
  # the budget table working as a psuedo category table.
  def self.balance(u_id, budget_name = '')
    if budget_name != ''
      total_expense = 0
      # retrieve the budget and calculate the balance using related tags
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
      tag_expense_totals = []
      self.all.each do |k, _|
        k.tags.each do |t|
          total_id = Transaction.where(:tags => t)
            .and(Sequel.extract(:month, :date) => Date.today.month)
            .and(:type => 'expense')
            .and(:user_id => u_id)
          unless total_id.nil?
            total_id = JSON.parse(total_id.to_json)
          end
          total = Transaction.select(:amount).where(:tags => t)
            .and(Sequel.extract(:month, :date) => Date.today.month)
            .and(:type => 'expense')
            .and(:user_id => u_id)
            .sum(:amount)
          unless total.nil? && total_id.first.nil?
            tag_expense_totals.push({:id => total_id.first["id"], :amount => total})
          end
        end
      end
      # group all amounts by id and then merge them if the :id is identical
      # reduce the amount array to a single value
      total_tag_expense = tag_expense_totals.group_by{ |h| h[:id] }.map{ |_, hs| hs.reduce(:merge)}
      # return the sum of the hash
      total_tag_expense = total_tag_expense.inject(0) {|sum, hash| sum + hash[:amount]}
      budget = self.sum(:spending_limit)

      {:budget_balance => (budget - total_tag_expense).round(2)}
    end
  end

  # Asking for the total spending limit
  def self.total?(u_id, budget_name = nil)
    return unless u_id
    if budget_name.nil?
      budget_total = select(:spending_limit)
        .where(:user_id =>  u_id)
        .sum(:spending_limit)
    else
      budget_total = select(:spending_limit)
        .where{(user_id =~ u_id) & (name =~ budget_name)}
        .sum(:spending_limit)
    end
  end

  # retrive the tag names and map them to a tag_names array
  def tag_data
    tags = []
    self.tags.each do |t|
      tags.push({:id => t.id, :name => t.name})
    end
  end
end
