require 'kredki'

service = service! do
  def sketch
    @value = 0
  end

  def +(value)
    @value += value
    value_changed
  end

  def -(value)
    @value -= value
    value_changed
  end

  def *(factor)
    @value *= factor
    value_changed
  end

  def value_changed
    pane[:note!].set "#{@value}"
  end
end

set layout: [:xcc, 5]

note! "0", size_x: 100, verse_layout: :yee
button! "++", on_click: proc{ service + 1 }
button! "--", on_click: proc{ service - 1 }
button! "*2", on_click: proc{ service * 2 }