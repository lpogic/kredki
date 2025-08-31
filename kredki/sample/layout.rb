require 'kredki'

# Standard layouts overview.

layouts = Kredki::UI.layout_map.keys

pad! color: :rand, wh: 140
pad! color: :rand, wh: 120
pad! color: :rand
l = layer

def button_text layout
  "Click here to change layout\nCurrent layout: #{layout || "nil"}"
end

layer! do
  button! do
    text << button_text(layouts.first)

    on_click! do
      layouts.rotate!
      text << button_text(layouts.first)
      l.layout! layouts.first
    end
  end
end