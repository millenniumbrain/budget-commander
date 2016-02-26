BudgetCommander.route('sms') do |r|
  r.is do
    r.post do
      text = r[:Body]
      case text
      when /(?:Add\sAccount)|(?:add\saccount)/
        account_name = text.match(/"(.*?)"/).to_a.first
        account_name = account_name.to_s.tr('\/"', '')
        new_account = Account.new(:name => account_name, :user_id => 1)
        new_account.save
        twiml = Twilio::TwiML::Response.new do |r|
          r.Message "Account #{account_name} successfully added!"
        end
        twiml.text
      when /(?:Delete\sAccount)|(?:delete\saccount)/
        account_name = text.match(/"(.*?)"/).to_a.first
        account_name = account_name.to_s.tr('\/"', '')
        account = Account.where(Sequel.ilike(account_name + '%')).first
        account.delete
        twiml = Twilio::TwiML::Response.new do |r|
          r.Message "Account #{account_name} successfully deleted!"
        end
        twiml.text
      when /(?:Add\sTransaction)|(?:add\stransaction)/
        account_name = text.match(/"(.*?)"/).to_a.first
        account_name = account_name.to_s.tr('\/"', '')
        account = Account.where('name = ?', account_name).to_json
        account = JSON.parse(account).first
        sign = text.match(/(\+|\-){1}/).to_a.first
        sign = sign.to_s
        type = ""
        if sign.eql? "+"
          type = "income"
        elsif sign.eql? "-"
          type = "expense"
        end
        amount = text.match(/\$(\d+)/).to_a.first
        amount = amount.tr('$', '').to_f
        date = text.match(/(?:[A-Z]{1}[a-z]{2}\s\d{2}\s\d{4})/).to_a.first
        description = text.split("\n").last
        new_transaction = Transaction.new do |t|
          t.amount = amount
          t.description = description
          t.type = type
          t.date = DateTime.strptime(date, '%b %d %Y')
          t.account_id = account["id"]
          t.user_id = 1
        end
        new_transaction.save
        twiml = Twilio::TwiML::Response.new do |r|
          r.Message "Transaction added successfully"
        end
        twiml.text
      when /(?:Delete\sTransaction)|(?:delete\stransaction)/
        description = text.match(/"(.*?)"/).to_a.first
        description = description.to_s.tr('\/"', '')
        transaction = Transaction.where(Sequel.ilike(:description, description + '%')).first
        transaction.delete
        twiml = Twilio::TwiML::Response.new do |r|
          r.Message "Transaction deleted successfully"
        end
        twiml.text
      when /(?:My\sIncome)|(?:my\sincome)/
        income = Total::Income.new.current_month
        twiml = Twilio::TwiML::Response.new do |r|
          r.Message "Your total income this month is \n+$%.2f" % income
        end
        twiml.text
      when /(?:My\sExpense)|(?:my\sexpense)/
        twiml = Twilio::TwiML::Response.new do |r|
          expense = Total::Expense.new.current_month
          r.Message "Your total expense this month is \n-$%.2f" % expense.abs
        end
        twiml.text
      when /(?:My\sNetworth)|(?:my\snetworth)/
        total_expense = Transaction.where('type = ?', 'expense').sum(:amount).round(2)
        total_income = Transaction.where('type = ?', 'income').sum(:amount).round(2)
        networth = total_income - total_expense
        if networth >= 0
          twiml = Twilio::TwiML::Response.new do |r|
            r.Message "Your total networth is \n+$%.2f" % networth
          end
          twiml.text
        else
          twiml = Twilio::TwiML::Response.new do |r|
            r.Message "Your total networth is \n-$%.2f" % networth.abs
          end
          twiml.text
        end
      when /(?:My\sTotals)|(?:my\stotals)/
        total_expense = Transaction.where('type = ?', 'expense').sum(:amount).round(2)
        total_income = Transaction.where('type = ?', 'income').sum(:amount).round(2)
        networth = total_income - total_expense
        income = Total::Income.new.current_month
        expense = Total::Expense.new.current_month
        if networth >= 0
          twiml = Twilio::TwiML::Response.new do |r|
            r.Message %Q(
  Your totals this month are
  Networth: + $#{networth}
  Income this Month + $#{income}
  Expense this Month - $#{expense}
  )
          end
          twiml.text
        else
          twiml = Twilio::TwiML::Response.new do |r|
            r.Message %Q(
  Your totals this month are
  Networth:\n - $#{networth.abs.round(2)}
  Income this Month:\n + $#{income}
  Expense this Month:\n - $#{expense}
  )
          end
          twiml.text
        end
      else
        twiml = Twilio::TwiML::Response.new do |r|
          r.Message %Q(Text Message is invalid valid commands are
Add Account
Delete Account
Add Transaction
Delete Transaction
My Income
My Expenses
My Networth
My Totals
)
        end
        twiml.text
      end
    end
  end
end
