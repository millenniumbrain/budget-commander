module Total
  class Expenses
    def initialize
      @transactions = DB[:transactions]
    end

    public

    def monthly(year: Time.now.strftime('%Y'))
      # defaults to the current year's expenses / 12.00
      expenses = get_expenses
      (expenses[year] / 12.00).round(2) # without .00 ruby assumes integer division
    end

    def annual(year: Time.now.strftime('%Y'))
      expenses = get_expenses
      expenses[year]
    end

    def all
      expenses = get_expenses
      expenses
    end


    private

    def get_expenses
      expenses = @transactions.filter{amount < 0}
        .select_group(Sequel.function(:strftime, '%Y', :created_at).as(:year))
        .select_append{sum(:amount).as(:income)}.inject({}) do |hash, item|
          hash[item[:year]] = item[:income] # create a hash from the dataset
          hash
        end
    end
  end
end
