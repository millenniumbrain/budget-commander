# Transaction model
class Transaction < Sequel::Model(:transactions)
  plugin :json_serializer

  many_to_one :user
  many_to_one :account
  many_to_many :tags


  def before_save
    # generate a uuid when saving the row
    self.uid = Druuid.gen
    # prevent the user from creating transactions without amount and types
    cancel_action if amount.nil?
    cancel_action if type.nil?
    super
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
      tags.push({:uid => t.uid, :name => t.name})
    end
    tags
  end
end
