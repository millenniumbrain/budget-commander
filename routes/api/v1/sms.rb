BudgetCommander.route('sms', 'v1') do |r|
  r.is do
    r.get do
    end
    
    r.post do
      text = r[:Body]
      wit_message = Wit::Message.new(text, ENV['WIT_ACCESS_TOKEN'])
      wit_message.send
      wit_message.response
      twiml =  Twilio::TwiML::Response.new do |r|
        r.Message "Message Recieved"
      end
      twiml.text
    end
  end
end