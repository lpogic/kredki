require 'kredki'

set layout: :ycc

names = service! do
  def sketch
    @last = 0
  end

  def next
    "#{@last += 1}"
  end
end

scroll! size: 1r do
  tree! size: [1r, Fit, x_limit: 1r..] do
    item! names.next do
      item! names.next
      item! names.next
    end
    item! names.next do
      item! names.next
      item! names.next
    end
  end
end

space! layout: [:xec, 5], margin: 5, y: End, size_y: Fit do
  tree = pane[:tree!]

  button!("Cut").on_click do
    tree.selected_items.each{|it| it.detach }
  end

  button!("Plant").on_click do
    (tree.selected_items.last || tree).item! names.next
  end

  button!("Transplant").on_click do
    a, b, *other = tree.selected_items
    a.put b if a && b
  end
end