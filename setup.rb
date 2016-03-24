require './models'

test_user = User.new do |u|
  u.email = 'example@email.com'
  u.name = 'test'
  u.password = 'password'
end

test_user.save
