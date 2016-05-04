class Transaction < Sequel::Model(:transactions)
  plugin :json_serializer
  many_to_one :user
  many_to_one :account
  many_to_many :tags
  
  def before_save
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
      .and(:type => 'expense')
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
        :expense => {
          :amount => expense.round(2),
          :updated_at => first_of_the_month
        }
      }
    end
  end

  def self.total(u_id)
    total_income = select(:amount)
      .where{(type =~ 'income') & (user_id =~ u_id)}
      .sum(:amount)
    total_expense = select(:amount)
      .where{(type =~ 'expense') & (user_id =~ u_id)}
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
  
  def self.total_income_by_month(u_id, year = nil)
    income = select(:amount, :date)
      .where(:user_id => u_id)
      .and(:type => 'income')
      .select_group(Sequel.function(:strftime, '%m-%Y', :date).as(:year))
      .select_append(sum(:amount).as(:income))
    income.inject({}) do |hash, item|
      hash[item[:year]] = item[:income]
      hash
    end
  end
  
  def total_expense_by_month(u_id, year = nil)
    expense = select(:amount, :date)
      .where(:user_id => u_id)
      .and(:type => 'expense')
      .select_group(Sequel.function(:strftime, '%m-%Y', :date).as(:year))
      .select_append(sum(:amount).as(:expense))
      expense.inject({}) do |hash, item|
        hash[item[:year]] = item[:expense]
        hash
      end
  end
  
  def self.add_using_sms(u_id, date, type, amount, desc, tags, account_name)
    if type.nil? && amount.nil?
      return "Transaction was not added. You did not specify a type or amount"
    end
    user = User[u_id]
    new_transaction = self.new
    unless account_name.nil?
      # look for the account name case insensitive
      found_account = Account.where(Sequel.ilike(:name, "#{account_name}%")).first
      if found_account.nil?
        new_account = Account.new(:user_id => user.id)
        new_account.name = account_name
        new_account.save
      else
      end
    end
    
    if date.nil?
      new_transaction.date = DateTime.now.new_offset(0)
    else
      new_transaction.date = date
    end
    
    if amount.nil?
      'Transaction was not added. Amount was not specified'
    else
      new_transaction.amount = amount
    end
    
    if type.nil?
      'Transaction was not added. A type was not specified'
    else
      new_transaction.type = type
    end
    
    if desc.nil?
      new_transaction.description = ""
    else
      new_transaction.description = desc
    end
    

    
    if new_transaction.save
      user.add_transaction(new_transaction)
      if found_account.nil?
        new_account.add_transaction(new_transaction)
      else
        found_account.add_transaction(new_transaction)
      end
      unless tags.nil?
        tags.each do |t|
          found_tag = Tag.where(Sequel.ilike(:name, "#{t["value"]}%")).first
          if found_tag.nil?
            new_tag = Tag.create(:name => t["value"])
            new_transaction.add_tag(new_tag)
          else
            new_transaction.add_tag(found_tag)
          end
        end
      end
      "Transaction added successfully!"
    else
      "Transaction failed to be added"
    end
    
  end
end
