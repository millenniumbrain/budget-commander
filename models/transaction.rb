class Transaction < Sequel::Model(:transactions)
  plugin :json_serializer
  many_to_one :user
  many_to_one :account
  many_to_many :tags

  def current_month_total(u_id, t_type = '')
    return unless u_id
    if t_type == ''
    else
    end
  end

  def self.current_month_income(u_id)
    income = select(:amount, :date)
      .where(:user_id => u_id)
      .and(:type => 'income'.freeze)
      .and(Sequel.extract(:month, :date) => Date.today.month)
      .sum(:amount)
    if income.nil?
      income = 0.00
      now = Date.today
      first_of_the_month = Date.new(now.year, now.month, 1)
      {
        :income => {
          :amount => income,
          :updated_at => first_of_the_month
        }
      }
    else
      {
        :income => {
          :amount => income.round(2),
          :updated_at => first_of_the_month
        }
      }
    end
  end

  def self.current_month_expense(u_id)
    expense = select(:amount, :date)
      .where(:user_id => u_id)
      .and(:type => 'expense'.freeze)
      .and(Sequel.extract(:month, :date) => Date.today.month)
      .sum(:amount)
    if expense.nil?
      expense = 0.00
      now = Date.today
      first_of_the_month = Date.new(now.year, now.month, 1)
      {
        :expense => {
          :amount => expense,
          :updated_at => first_of_the_month
        }
      }
    else
      {
        :income => {
          :amount => income.round(2),
          :updated_at => first_of_the_month
        }
      }
    end
  end

  def self.total(u_id)
    total_income = select(:amount)
      .where{(type =~ 'income'.freeze) & (user_id =~ u_id)}
      .sum(:amount)
    total_expense = select(:amount)
      .where{(type =~ 'expense'.freeze) & (user_id =~ u_id)}
      .sum(:amount)
    if !total_income.nil? && !total_expense.nil?
      total = (total_income - total_expense).round(2)
    else
      total = 0.00
    end
  end

  def tag_names
    self.tags.map(&:name)
  end
end
