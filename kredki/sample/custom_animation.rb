require 'kredki'

mouse_in_scale = proc do
  on_mouse_enter.animate(400){|ms, d| zoom! 1.1 + 0.15 * Util.sin01(ms / d) }
  on_mouse_leave.animate(400){|ms, d| zoom! 1.15 - 0.15 * Util.sin01(ms / d) }
end

layout! :xcc
spacer! 10

button! "One", mouse_in_scale
button! "Hello", mouse_in_scale
button! "Two", mouse_in_scale, suit: :green
