require 'kredki'

Kredki.plugin! :mouse_in_scale do
  on_mouse_enter.animate(500){|ms, d| mag! 1 + Util.sin01(ms, d * 2) / d / 8 }
  on_mouse_leave.animate(500){|ms, d| mag! 1 + Util.sin01(ms + d * 2, d * 2) / d / 8 }
end

layout! :xcc
mi! 10

button! "One", :mouse_in_scale
button! "Hello", :mouse_in_scale
button! "Two", :mouse_in_scale, suit: :green
