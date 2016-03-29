class Transaction < Sequel::Model(:transactions)
  plugin :json_serializer
  many_to_one :user
  many_to_one :account
  many_to_many :tags

  def self.current_month_total(u_id, t_type = '')
    return unless u_id
    if t_type != ''
      current_month_total = select(:amount, :date)
        .where{(type =~ t_type) & (user_id =~ u_id)}
        .where(Sequel.extract(:month, :date) => Date.today.month)
        .sum(:amount)
    else
      current_month_income = select(:amount, :date)
        .where{(type =~ 'income') & (user_id =~ u_id)}
        .where(Sequel.extract(:month, :date) => Date.today.month)
        .sum(:amount)
      current_month_expense = select(:amount, :date)
        .where{(type =~ 'expense') & (user_id =~ u_id)}
        .where(Sequel.extract(:month, :date) => Date.today.month)
        .sum(:amount)
    end
    if current_month_total.nil? && t_type == 's'
      0
    elsif !current_month_total.nil?
      current_month_total.round(2)
    else
      {
        "income" => current_month_income,
        "expense" => current_month_expense
      }
    end
  end
  
  def self.current_month_total_by_tag(u_id, t_type, tag_name = '')
    return unless u_id
    current_month_total = select(:amount).where(:tags => tag_name)
      .and(:type => t_type)
      .and(:user_id => u_id)
      .sum(:amount)
    if current_month_total.nil?
      0
    else
      current_month_total.round(2)
    end
  end

  def self.total(u_id, t_type = '')
    return nil unless t_type.is_a? String
    if t_type != ''
      total = select(:amount)
      .where('type = ?', t_type)
      .sum(:amount)
    else
      total_income = select(:amount)
        .where{(type =~ 'income') & (user_id =~ u_id)}
        .sum(:amount)
      total_expense = select(:amount)
        .where{(type =~ 'expense') & (user_id =~ u_id)}
        .sum(:amount)
      total = total_income - total_expense
    end
    if total.nil?
      0
    else
      total.round(2)
    end
  end
end
