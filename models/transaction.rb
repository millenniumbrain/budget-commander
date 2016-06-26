# Transaction model
class Transaction < Sequel::Model(:transactions)
  plugin :json_serializer

  many_to_one :user
  many_to_one :account
  many_to_many :tags


  def before_save
    # generate a uuid when saving the row
    self._id = SecureRandom.uuid
    # prevent the user from creating transactions without amount and types
    cancel_action if amount.nil?
    cancel_action if type.nil?
    super
  end

  def self.current_month_income(u_id)
    income = select(:amount, :date)
      .where(:user_id => u_id)
      .and(:type => 'income')
      .and(Sequel.extract(:month, :date) => Date.today.month)
      .sum(:amount)
    if income.nil?
      income = 0.00
      now = Date.today
      format("%.2f", income)
    else
      format("%.2f", income)
    end
  end

  def self.current_month_expense(u_id)
    expense = select(:amount, :date)
      .where(:user_id => u_id)
      .and(:type => 'expense')
      .and(Sequel.extract(:month, :date) => Date.today.month)
      .sum(:amount)
    if expense.nil?
      expense = 0.00
      now = Date.today
      format("%.2f", expense)
    else
      format("%.2f", expense)
    end
  end

  def self.total(u_id)
    total_income = select(:amount)
      .where{ (type =~ 'income') & (user_id =~ u_id) }
      .sum(:amount)
    total_expense = select(:amount)
      .where{ (type =~ 'expense') & (user_id =~ u_id) }
      .sum(:amount)
    if !total_income.nil? && !total_expense.nil?
      total = (total_income - total_expense).round(2)
    else
      total = 0.00
    end
  end

  def self.total_income_by_month(u_id, year = nil)
    income = select(:amount, :date)
             .where(user_id: u_id)
             .and(type: 'income')
             .select_group(Sequel.function(:strftime, '%m-%Y', :date).as(:year))
             .select_append(Sequel.function(:round, sum(:amount), 2).as(:income))
    income.each_with_object({}) do |item, hash|
      hash[item[:year]] = item[:income]
    end
  end

  def self.total_expense_by_month(u_id, year = nil)
    expense = select(:amount, :date)
              .where(:user_id => u_id)
              .and(:type => 'expense')
              .select_group(Sequel.function(:strftime, '%m-%Y', :date).as(:year))
              .select_append(Sequel.function(:round, sum(:amount), 2).as(:expense))
    expense.each_with_object({}) do |item, hash|
      hash[item[:year]] = item[:expense]
    end
  end

  def tags_data
    tags = []
    self.tags.each do |t|
      tags.push({:_id => t._id, :name => t.name})
    end
    tags
  end
end
