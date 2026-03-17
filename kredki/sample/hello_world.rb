require 'kredki'

set_layout :xss # how pads are positioned by default
set_spacer 10 # distance between pads

button! do
  text! "Say hello"
  on_click do
    puts "Hello world!"
  end
end

button! "Exit", on_click: proc{ window.close }