require 'rtesseract'
require 'mini_magick'
require 'pp'

RTesseract.configure do |config|
  config.processor = "mini_magick"
end

img = MiniMagick::Image.open('test2.jpg')
img.write 'test2.png'

begin
  image = RTesseract.new('test2.png') do |img|
    img = img.white_threshold(255)
    img = img.quantize(256, MiniMagick::GRAYColorspace)
  end
  pp image.to_s
end
