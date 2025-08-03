require 'kredki'

color! 10, 30, 10
layout! :center

button! m: 5 do
  text << "Hello world!"
  on_click! do
    R.terminate!
  end
end