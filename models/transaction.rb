class Transaction < Sequel::Model(:transactions)
  plugin :json_serializer
  many_to_one :user
  many_to_one :account
  many_to_many :tags

  def self.current_month_total(type)
    return nil unless type.is_a? String
    current_month_total = select(:amount, :date)
      .where('type = ?', type)
      .where(Sequel.extract(:month, :date) => Date.today.month.sum(:amount))
      .round(2)
    if current_month_total.nil?
      0
    else
      current_month_total
    end
  end

  def self.total(type = '')
    return nil unless type.is_a? String
    if type != ''
      total = select(:amount)
        .where('type = ?', type)
        .sum(:amount)
        .round(2)
    else
      total_income = select(:amount)
        .where('type = ?', 'income')
        .sum(:amount)
        .round(2) 
      total_expense = select(:amount)
        .where('type = ?', 'expense')
        .sum(:amount)
        .round(2)
      total = total_income - total_expense
    end
    if total.nil?
      0
    else
     total 
    end
  end
end
