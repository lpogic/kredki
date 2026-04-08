require 'kredki'

# Standard layouts overview.

layouts = Kredki::Pads.layout_map.keys

pad! fill: :random, size: 140
pad! fill: :random, size: 120
pad! fill: :random, size: 100
base_layer = layer

service! do
  def button_text_input layout
    "Click here to change layout\nCurrent layout: #{layout ? ":#{layout}" : "nil"}"
  end
end

pane.layer! do
  button! do
    text! pane.service?.button_text_input(layouts.first)

    on_click do
      layouts.rotate!
      set pane.service?.button_text_input(layouts.first)
      base_layer.set_layout layouts.first
    end
  end
end