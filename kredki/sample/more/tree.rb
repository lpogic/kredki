require 'kredki'

set layout: :ycc

service! :next_name do
  def sketch
    @value = 0
  end

  def call
    "#{@value += 1}"
  end
  end

scroll! size: 1r do
  tree! size: [1r, Fit, x_limit: 1r..] do
    item! pane[:next_name].call do
      item! pane[:next_name].call
      item! pane[:next_name].call
    end
    item! pane[:next_name].call do
      item! pane[:next_name].call
      item! pane[:next_name].call
    end
  end
end

space! layout: [:xec, 5], margin: 5, y: End, size_y: Fit do
  tree = pane.tree?

  button!("Cut").on_click do
    tree.selected_items.each{|it| it.detach }
  end

  button!("Plant").on_click do
    (tree.selected_items.last || tree).item! pane[:next_name].call
  end

  button!("Transplant").on_click do
    a, b, *other = tree.selected_items
    a.put b if a && b
  end
end