require 'kredki'

window[:mouse_in_scale] do
  on_mouse_enter.animate(400){|ms, d| mag! 1.1 + 0.15 * Util.sin01(ms.to_f / d) }
  on_mouse_leave.animate(400){|ms, d| mag! 1.15 - 0.15 * Util.sin01(ms.to_f / d) }
end

layout! :xcc
mi! 10

button! "One", window[:mouse_in_scale]
button! "Hello", window[:mouse_in_scale]
button! "Two", window[:mouse_in_scale], suit: :green
