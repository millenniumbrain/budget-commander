# Tag model
class Tag < Sequel::Model(:tags)
  plugin :json_serializer
  many_to_one :user
  many_to_many :transactions

  def before_save
    # generate a uuid when saving the row
    self.uid = Druuid.gen
    super
  end

  def transaction_total
    total = 0
    self.transactions.each do |t|
      case t.type
      when "expense"
        total += -t.amount
      when "income"
        total += t.amount
      end
    end
    format('%.2f', total)
  end
end
