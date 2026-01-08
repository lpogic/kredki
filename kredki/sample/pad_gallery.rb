require 'kredki'

action.on_focus_leave! do
  window.terminate!
end

layout! :yss

toolbar! do
  item! "File"
  item! "Edit"
  item! "Help" do
    item! "About"
    item! "Test" do
      item! "Level"
    end
  end
end

context! do
  item! "Cut"
  item! "Copy"
  item! "Paste"
  item! "More.." do
    item! "Find"
    item! "Replace"
  end
end

space! layout: :xss, margin: 10, margin_i: 10 do
  space! layout: :yss, margin_i: 10 do
    note! w: 1r
    list! w: 1r, h: :fit do
      item! "First"
      item! "Second", icon: pad!(h: 24, w: 16, area: proc{ellipse! _2 * 0.2})
      item! "Third", icon: animation!("sketch/1643-exploding-star.json", wh: 16, play: :bounce_loop)
    end
    space! layout: :xss, margin_i: 10 do
      yslide!
      space! layout: :yss, margin_i: 10 do
        text! "Some text"
        xslide!
      end
      tree! do
        item! "Branch", icon: pad!(h: 24, w: 16, area: proc{ellipse! _2 * 0.2})
        item! "Branch", icon: pad!(h: 24, w: 16, area: proc{ellipse! _2 * 0.2}) do
          item! "Branch", icon: pad!(h: 24, w: 16, area: proc{ellipse! _2 * 0.2}) do
            item! "Branch", icon: pad!(h: 24, w: 16, area: proc{ellipse! _2 * 0.2})
          end
        end
      end
    end
    scroll! wh: [1r, limit: :fit] do
      picture! "sketch/test.png"
    end
  end
  space! layout: :yss, w: 1/2r, margin_i: 10 do
    notes! w: 1r
    option! w: 1r do
      item! "Red"
      item! "Green"
      item! "Blue"
      item! content: :test
      item! content: 1234
    end
    labeled_check! "Check A"
    labeled_check! "Check B"
    radio! do
      labeled_item! "Radio 1"
      labeled_item! "Radio 2"
      labeled_item! "Radio 3"
    end
    animation! "sketch/1643-exploding-star.json", wh: [1r, limit: :ratio], x: :c, play: :bounce_loop
  end
end
