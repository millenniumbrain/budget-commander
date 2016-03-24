require 'rtesseract'
require 'pp'

RTesseract.configure do |config|
  config.processor = "mini_magick"
end

begin
  image = RTesseract.new('ReceiptSwiss.jpg') do |img|
    cool = img.white_threshold(245)
    cool = img.quantize(256, MiniMagick::GRAYColorspace)
  end
  puts image.to_s
end
