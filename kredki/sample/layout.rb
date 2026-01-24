require 'kredki'

# Standard layouts overview.

layouts = Kredki::Pads.layout_map.keys

pad! fill: :rand, wh: 140
pad! fill: :rand, wh: 120
pad! fill: :rand, wh: 100
l = layer

define :button_text_input do |layout|
  "Click here to change layout\nCurrent layout: #{layout ? ":#{layout}" : "nil"}"
end

window.layer! do
  button! do
    text! button_text_input(layouts.first)

    on_click do
      layouts.rotate!
      fd(TextPad) << button_text_input(layouts.first)
      l.layout! layouts.first
    end
  end
end