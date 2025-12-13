require 'kredki'

layout! :xbb # how pads are positioned by default
margin_i! 10 # distance between pads

button! do
  text << "Say hello"
  on_click! do
    puts "Hello world!"
  end
end

button! "Exit", on_click: proc{ K.terminate! }