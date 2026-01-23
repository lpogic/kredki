require 'kredki'

# Standard layouts overview.

layouts = Kredki::UI.layout_map.keys

pad! fill: :rand, wh: 140
pad! fill: :rand, wh: 120
pad! fill: :rand, wh: 100
l = layer

def button_text_input layout
  "Click here to change layout\nCurrent layout: #{layout ? ":#{layout}" : "nil"}"
end

layer! do
  button! do
    text! button_text_input(layouts.first)

    on_click do
      layouts.rotate!
      fd(Text) << button_text_input(layouts.first)
      l.layout! layouts.first
    end
  end
end