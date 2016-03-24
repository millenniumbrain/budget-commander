class Transaction < Sequel::Model(:transactions)
  plugin :json_serializer
  many_to_one :user
  many_to_one :account
  many_to_many :tags

  def self.current_month_total(t_type, t_user_id)
    return nil unless t_type.is_a? String
    if t_type.nil?
      current_month_total = select(:amount, :date)
        .where{(type =~ t_type) & (user_id =~ t_user_id)}
        .where(Sequel.extract(:month, :date) => Date.today.month)
        .sum(:amount)
    else
      current_month_total = select(:amount, :date)
        .where('type = ?' , t_type)
        .where(Sequel.extract(:month, :date) => Date.today.month)
        .sum(:amount)
    end
    if current_month_total.nil?
      0
    else
      current_month_total.round(2)
    end
  end

  def self.total(t_type = '', t_user_id)
    return nil unless t_type.is_a? String
    if t_type != ''
      total = select(:amount)
      .where('type = ?', t_type)
      .sum(:amount)
    else
      total_income = select(:amount)
      .where('type = ?', 'income')
      .sum(:amount)
      total_expense = select(:amount)
      .where('type = ?', 'expense')
      .sum(:amount)
      unless total.nil?
        total = total_income - total_expense
      end
    end
    if total.nil?
      0
    else
      total
    end
  end
end
