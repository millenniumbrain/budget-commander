module Total
  class Income

    def initialize
      @transactions = DB[:transactions]
    end

    public

    def monthly(year: Time.now.strftime('%Y'))
      # defaults to the current year's income / 12.00
      income = get_income
      (income[year] / 12.00).round(2)
    end

    def annual(year: Time.now.strftime('%Y'))
      income = get_income
      income[year]
    end

    def by_month
    end

    def all
      income = get_income
    end

    private

    def get_income
      income = @transactions.filter{amount > 0}
        .select_group(Sequel.function(:strftime, '%Y', :created_at).as(:year))
        .select_append{sum(:amount).as(:income)}.inject({}) do |hash, item|
          hash[item[:year]] = item[:income] # create a hash from the dataset
          hash
        end
    end
  end
end
