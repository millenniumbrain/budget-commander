module Total
  class Income

    def initialize
      @transactions = DB[:transactions]
    end

    def monthly(year = Time.now.strftime('%Y'))
      # defaults to the current year's income / 12.00
      if total_income.length > 0
        income = total_income
        (income[year] / 12.00).round(2)
      else
        0
      end
    end

    def annual(year = Time.now.strftime('%Y'))
      income = total_income
      income[year]
    end

    def current_month
      @transactions.select(:amount, :date)
      .where('type = ?', 'income')
      .where(Sequel.extract(:month, :date) => Date.today.month).sum(:amount)
    end

    def by_month
      if @transactions.select(:type).where('type = ?', 'income').count > 0
        income = @transactions.select(:amount, :date).where('type = ?', 'income')
        .select_group(Sequel.function(:strftime, '%Y-%m', :date).as(:date))
        .select_append{sum(:amount).as(:income)}

        income.inject({}) do |hash, item|
          month = DateTime.strptime(item[:date], '%Y-%m').strftime('%b')
          hash[month] = item[:income].round(2)
          hash
        end
      else
        []
      end
    end


    def total_income
      if @transactions.where('type = ?', 'income').count > 0
        expenses = @transactions.where('type = ?', 'income')
        .select_group(Sequel.function(:strftime, '%Y', :date).as(:year))
        .select_append{sum(:amount).as(:expenses)}
        expenses.inject({}) do |hash, item|
          hash[item[:year]] = item[:expenses] # create a hash from the dataset
          hash
        end
      else
        []
      end
    end
  end
end
