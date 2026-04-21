require 'kredki'

set layout: :ycc

scroll! size: 1r do
  tree! size: [1r, Fit, x_limit: 1r..] do
    item! "A" do
      item! "B"
      item! "C"
    end
    item! "A" do
      item! "B"
      item! "C"
    end
  end
end

space! layout: :xec, spacer: 5, margin: 5, y: End, size_y: Fit do
  tree = pane.tree?

  button!("Delete").on_click do
    tree.selected_items.each{|it| it.detach }
  end

  button!("Put").on_click do
    (tree.selected_items.last || tree).item! "X"
  end

  button!("Move").on_click do
    a, b, *c = tree.selected_items
    a.put b if a && b
  end
end