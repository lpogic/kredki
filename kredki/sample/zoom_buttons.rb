require 'kredki'

mouse_in_zoom = proc do
  on_mouse_enter.animate(400){|ms, d| set_zoom 1.1 + 0.15 * Util.sin01(ms / d) }
  on_mouse_leave.animate(400){|ms, d| set_zoom 1.15 - 0.15 * Util.sin01(ms / d) }
end

set_layout :xcc
set_spacer 10

button! "One", mouse_in_zoom
button! "Hello", mouse_in_zoom
button! "Two", mouse_in_zoom, suit: :green
