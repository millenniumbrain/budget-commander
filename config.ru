require './app'

map '/assets' do
  run Rack::File.new('public')
end

map '/bower_components' do
  run Rack::File.new('public/bower_components')
end
map '/css' do
  run Rack::File.new('public/css')
end

map '/js' do
  run Rack::File.new('public/js')
end

map '/img' do
  run Rack::File.new('public/img')
end

map '/fonts' do
  run Rack::File.new('public/fonts')
end

use Rack::Deflater
run BudgetCommander
