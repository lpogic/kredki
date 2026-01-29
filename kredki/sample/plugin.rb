require 'kredki'

window.plugin! :mouse_in_scale do
  on_mouse_enter.animate(400){|ms, d| mag! 1.1 + 0.2 * Util.sin01(ms.to_f / d) }
  on_mouse_leave.animate(400){|ms, d| mag! 1.2 - 0.2 * Util.sin01(ms.to_f / d) }
end

layout! :xcc
mi! 10

button! "One", :mouse_in_scale
button! "Hello", :mouse_in_scale
button! "Two", :mouse_in_scale, suit: :green
