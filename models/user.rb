class User < Sequel::Model(:users)
  include BCrypt

  one_to_many :accounts
  one_to_many :budgets
  one_to_many :tags
  one_to_many :transactions

  def self.login(username, password)
    return unless username && password
    return unless user = filter(name: username).first
    return unless BCrypt::Password.new(user.password_hash) == password
    true
  end

  def self.login_id(username)
    return unless username
    return unless user = filter(name: username).first
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
