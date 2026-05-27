require 'kredki'

mouse_in_zoom = proc do
  on_mouse_enter.play(400){|it| set_zoom 1.10 + 0.15 * Util.sin01(it.progress) }
  on_mouse_leave.play(400){|it| set_zoom 1.15 - 0.15 * Util.sin01(it.progress) }
end

set_layout :xcc, 10

button! "One", mouse_in_zoom
button! "Hello", mouse_in_zoom
button! "Two", mouse_in_zoom, suit: :green
