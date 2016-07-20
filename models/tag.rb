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
end
