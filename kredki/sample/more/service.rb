require 'kredki'

service! do
  def sketch
    @value = 0
  end

  def increment
    @value += 1
    value_changed
  end

  def decrement
    @value -= 1
    value_changed
  end

  def double
    @value *= 2
    value_changed
  end

  def value_changed
    pane.note?.set "#{@value}"
  end
end

set layout: :xcc, spacer: 5

note! "0", size_x: 100, verse_layout: :yee
button! "++", on_click: proc{ service?.increment }
button! "--", on_click: proc{ service?.decrement }
button! "*2", on_click: proc{ service?.double }