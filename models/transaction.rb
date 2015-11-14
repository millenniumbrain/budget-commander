class Transaction < Sequel::Model(:transactions)
  plugin :json_serializer
  many_to_one :user
  many_to_one :account
  many_to_many :tags
  
  def self.income(year: Time.now.strftime('%Y'), monthly: false, annual: false)
    # defaults to the current year's income / 12.00
    income = filter{amount > 0}
      .select_group(Sequel.function(:strftime, '%Y', :created_at).as(:year))
      .select_append{sum(:amount).as(:income)}.inject({}) do |hash, item|
        hash[item[:year]] = item[:income] # create a hash from the dataset
        hash
      end
    if monthly
      income[year] / 12.00 # without .00 ruby assumes integer division
    else
      if annual
        income[year]
      else
        income
      end
    end
  end
  
  def self.expenses(year = Time.now.strftime('%Y'), monthly: false, annual: false)
    # defaults to the current year's expenses / 12.00
    expenses = filter{amount < 0}
      .select_group(Sequel.function(:strftime, '%Y', :created_at).as(:year))
      .select_append{sum(:amount).as(:income)}.inject({}) do |hash, item|
        hash[item[:year]] = item[:income] # create a hash from the dataset
        hash
      end
    if monthly
      expenses[year] / 12.00 # without .00 ruby assumes integer division
    else
      if annual
        expenses[year]
      else
        expenses
      end
    end
  end
end
