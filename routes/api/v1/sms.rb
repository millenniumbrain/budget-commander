BudgetCommander.route('sms', 'v1') do |r|
  r.is do
    r.get do
    end
    
    r.post do
      user = User[1]
      pp r[:Body]
      text = r[:Body]
      wit_message = Wit::Message.new(text, ENV['WIT_ACCESS_TOKEN'])
      begin
        wit_message.send
      rescue
        twiml =  Twilio::TwiML::Response.new do |res|
          res.Message "Could not read message."
        end
        twiml.text
      end

      case wit_message.entity_value("intent")
      when "add_transaction"
        message = Transaction.add_using_sms(1, 
          wit_message.entity_value("date"),
          wit_message.entity_value("transaction_type"),
          wit_message.entity_value("amount_of_money"),
          wit_message.entity_value("transaction_desc"),
          wit_message.entity("tag_name"),
          wit_message.entity_value("account_name")
        )
        twiml = Twilio::TwiML::Response.new do |res|
          res.Message message
        end
        twiml.text
      else
        twiml = Twilio::TwiML::Response.new do |res|
          res.Message "Command not valid"
        end
        twiml.text        
      end
    end
  end
end