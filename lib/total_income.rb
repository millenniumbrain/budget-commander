module Total
  class Income
    include Concurrent::Async

    def initialize
    end

    def monthly(year: Time.now.strftime('%Y'))
      # defaults to the current year's income / 12.00
      income = total_income
      (income[year] / 12.00).round(2)
    end

    def annual(year: Time.now.strftime('%Y'))
      income = total_income
      income[year]
    end

    def by_month
      if DB[:transactions].where('type = ?', 'income').count > 0
        income = Concurrent::Promise.new do
          DB[:transactions].where('type = ?', 'income')
          .select_group(Sequel.function(:strftime, '%Y-%m', :date).as(:date))
          .select_append{sum(:amount).as(:income)}
        end.then do |result|
          result.inject({}) do |hash, item|
            month = DateTime.strptime(item[:date], '%Y-%m').strftime('%b')
            hash[month] = item[:income].round(2)
            hash
          end
        end.execute
        income.value
      else
        []
      end
    end

    private

    def total_income
      income = Concurrent::Promise.new do
        DB[:transactions].where('type = ?', 'income')
        .select_group(Sequel.function(:strftime, '%Y', :date).as(:year))
        .select_append{sum(:amount).as(:income)}
      end.then do |result|
        result.inject({}) do |hash, item|
          hash[item[:year]] = item[:income] # create a hash from the dataset
          hash
        end
      end.execute
      income.value
    end
  end
end
