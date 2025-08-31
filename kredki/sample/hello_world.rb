require 'kredki'

# A simple but expressive api sample.

layout! X, 10

button! do
  text << "Say hello"
  on_click! do
    puts "Hello world!"
  end
end

button! "Exit", on_click: proc{ K.terminate! }