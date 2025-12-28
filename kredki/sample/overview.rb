require 'kredki'

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
    space! layout: :xss, margin_i: 10 do
      yslide!
      space! layout: :yss, margin_i: 10 do
        text! "Some text"
        xslide!
      end
    end
    scroll! w: [1r, limit: :fit], h: 150 do
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
