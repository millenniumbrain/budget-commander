module Total
  class Expense

    def initialize
      @transactions = DB[:transactions]
    end

    public

    def monthly(year: Time.now.strftime('%Y'))
      # check if empty transaction array is returned
      if total_expenses.length > 0
        # defaults to the current year's expenses / 12.00
        expenses = total_expenses
        (expenses[year] / 12.00).round(2) # without .00 ruby assumes integer division
      else
        0
      end
    end

    def annual(year = Time.now.strftime('%Y'))
      if total_expenses.length > 0
        expenses = total_expenses
        expenses[year]
      else
        0
      end
    end

    def all
      expenses = total_expenses
      expenses
    end

    def by_month
      if @transactions.where('type = ?', 'expense').count > 0
        # create a new promise to set expenses
        # find expenses and group by year and month
        # then append sum of the amount to the dataset
        expenses = @transactions.select(:amount, :date).where('type = ?', 'expense')
        .select_group(Sequel.function(:strftime, '%Y-%m', :date).as(:date))
        .select_append{sum(:amount).as(:expenses)}
        expenses.inject({}) do |hash, item|
          month = DateTime.strptime(item[:date], '%Y-%m').strftime('%b')
          hash[month] = item[:expenses].round(2) # remove trailing decimals
          hash
        end
      else
        []
      end
    end

    def current_month
      @transactions.select(:amount, :date)
      .where('type = ?', 'expense')
      .where(Sequel.extract(:month, :date) => Date.today.month).sum(:amount)
    end

    private

    def total_expenses
      if @transactions.where('type = ?', 'expense').count > 0
        expenses = @transactions.where('type = ?', 'expense')
        .select_group(Sequel.function(:year, :date).as(:year))
        .select_append{sum(:amount).as(:expenses)}
        expenses.inject({}) do |hash, item|
          hash[item[:year]] = item[:expenses] # create a hash from the dataset
          hash
        end
      else
        []
      end
    end

    def total_expenses_by_month
    end
  end
end
