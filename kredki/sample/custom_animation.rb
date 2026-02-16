require 'kredki'

MouseInScale = proc do
  on_mouse_enter.animate(400){|ms, d| mag! 1.1 + 0.15 * Util.sin01(ms / d) }
  on_mouse_leave.animate(400){|ms, d| mag! 1.15 - 0.15 * Util.sin01(ms / d) }
end

layout! :xcc
mi! 10

button! "One", MouseInScale
button! "Hello", MouseInScale
button! "Two", MouseInScale, suit: :green
