class User < Sequel::Model(:users)
  include BCrypt

  one_to_many :accounts
  one_to_many :tags
  one_to_many :transactions

  def before_save
    # generate a uuid when saving the row
    self.uid = Druuid.gen
    super
  end

  # if the user exisits and the password matches return true
  def self.login(email, password)
    return unless email && password
    return unless user = filter(email: email).first
    return unless BCrypt::Password.new(user.password_hash) == password
    return true
  end

  def self.password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
