module Transactions
  class TotalExpense
    class << self
      def this_month(user_id)
        expense = Transaction
        .select(:amount, :date)
        .where(user_id: user_id)
        .and(type: 'expense')
        .and(Sequel.extract(:month, :date) => Date.today.month)
        .sum(:amount)
        
        if expense.nil?
          format("%.2f", expense)
        elsif expense == 0
          format("%.2f", expense)
        else
          format("-%.2f", expense)
        end
      end
      
      def this_year
      end
      
      def month(month, year = Date.new.year)
      end
      
      def year(year)
      end
      
      def total(user_id)
        expense = Transaction.select(:amount, :date).where(user_id: user_id)
        .and(type: 'expense')
        .sum(:amount)
        if expense.nil?
          expense = 0
          format("%.2f", expense)
        elsif expense == 0
          format("%.2f", expense)
        else
          format("-%.2f", expense)
        end
      end
    end
  end
end