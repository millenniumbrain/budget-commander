module Transactions
  class Total
    class << self
      def networth(user_id)
        networth = Transactions::TotalIncome.total(user_id).to_f + Transactions::TotalExpense.total(user_id).to_f
        if networth < 0
          format("%.2f", networth)
        else
          format("%.2f", networth)
        end
      end
    end
  end
end