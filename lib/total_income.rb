module Transactions
  class TotalIncome
    class << self
      def this_month(user_id)
        income = Transaction
        .select(:amount, :date)
        .where(user_id: user_id)
        .and(type: 'income')
        .and(Sequel.extract(:month, :date) => Date.today.month)
        .sum(:amount)
        
        if income.nil?
          income = 0
        end
        format("%.2f", income)
      end
      
      def total(user_id)
        income = Transaction.select(:amount).where(user_id: user_id)
        .and(type: 'income')
        .sum(:amount)
      end
    end
  end
end