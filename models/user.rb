class User < Sequel::Model(:users)
  include BCrypt

  one_to_many :accounts
  one_to_many :budgets
  one_to_many :tags
  one_to_many :transactions
  one_to_many :receipts
  many_to_many :groups

  def before_save
    self._id = SecureRandom.uuid
    super
  end
  
  def self.login(email, password)
    return unless email && password
    return unless user = filter(email: email).first
    return unless BCrypt::Password.new(user.password_hash) == password
    true
  end

  def self.login_id(email)
    return unless email
    return unless user = filter(email: email).first
    user.id
  end

  def self.password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
