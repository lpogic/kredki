require 'kredki'

# Standard layouts overview.

layouts = Kredki::Pads.layout_map.keys

pad! fill: :random, size: 140
pad! fill: :random, size: 120
pad! fill: :random, size: 100
base_layer = layer

Button.define :button_text_input do |layout|
  "Click here to change layout\nCurrent layout: #{layout ? ":#{layout}" : "nil"}"
end

pane.layer! do
  button! do
    text! button_text_input(layouts.first)

    on_click do
      layouts.rotate!
      find_upper(TextPad) << button_text_input(layouts.first)
      base_layer.set_layout layouts.first
    end
  end
end