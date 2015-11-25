module Total
  class Income

    class << self
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


      def by_month
        income = DB[:transactions].filter{amount >= 0}
          .select_group(Sequel.function(:strftime, '%Y-%m', :date).as(:date))
          .select_append{sum(:amount).as(:income)}.inject({}) do |hash, item|
            month = DateTime.strptime(item[:date], '%Y-%m').strftime('%b')
            hash[month] = item[:income].round(2)
            hash
          end
          income
      end

      private

      def get_income
        income = DB[:transactions].filter{amount > 0}
          .select_group(Sequel.function(:strftime, '%Y', :date).as(:year))
          .select_append{sum(:amount).as(:income)}.inject({}) do |hash, item|
            hash[item[:year]] = item[:income] # create a hash from the dataset
            hash
          end
      end
    end
  end
end
