class Account < Sequel::Model(:accounts)
  plugin :json_serializer

  many_to_one :user
  one_to_many :transactions

  def before_save
    # generate a uuid when saving the row
    self.uid = Druuid.gen
    super
  end

end
