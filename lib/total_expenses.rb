module Total
  class Expenses
    class << self
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

      def by_month
        expenses = DB[:transactions].filter{amount < 0}
          .select_group(Sequel.function(:strftime, '%Y-%m', :date).as(:date))
          .select_append{sum(:amount).as(:expenses)}.inject({}) do |hash, item|
            month = DateTime.strptime(item[:date], '%Y-%m').strftime('%b')
            hash[month] = item[:expenses].round(2)
            hash
          end
          expenses
      end

      private

      def get_expenses
        expenses = DB[:transactions].filter{amount < 0}
          .select_group(Sequel.function(:strftime, '%Y', :date).as(:year))
          .select_append{sum(:amount).as(:expenses)}.inject({}) do |hash, item|
            hash[item[:year]] = item[:expenses] # create a hash from the dataset
            hash
          end
      end
    end
  end
end
