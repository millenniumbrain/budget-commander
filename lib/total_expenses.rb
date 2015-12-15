module Total
  class Expenses
    include Concurrent::Async

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

    def annual(year: Time.now.strftime('%Y'))
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
        expenses =  Concurrent::Promise.new do
          # find expenses and group by year and month
          # then append sum of the amount to the dataset
          @transactions.where('type = ?', 'expense')
          .select_group(Sequel.function(:strftime, '%Y-%m', :date).as(:date))
          .select_append{sum(:amount).as(:expenses)}
        end.then do |result|
          # create a new hash converting utc to a %Y-%m a string
          result.inject({}) do |hash, item|
            month = DateTime.strptime(item[:date], '%Y-%m').strftime('%b')
            hash[month] = item[:expenses].round(2) # remove trailing decimals
            hash
          end
        end.execute
        # if the promise is fulfilled return a value
        expenses.value
      else
        []
      end
    end

    private

    def total_expenses
      if @transactions.where('type = ?', 'expense').count > 0
        expenses = Concurrent::Promise.new do
          @transactions.where('type = ?', 'expense')
            .select_group(Sequel.function(:strftime, '%Y', :date).as(:year))
            .select_append{sum(:amount).as(:expenses)}
        end.then do |result|
            result.inject({}) do |hash, item|
              hash[item[:year]] = item[:expenses] # create a hash from the dataset
              hash
            end
        end.execute
        expenses.value
      else
        []
      end
    end

    def total_expenses_by_month
    end
  end
end
