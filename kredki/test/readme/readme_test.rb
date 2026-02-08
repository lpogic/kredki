require 'kredki/test'

class HelloTest < Kredki::Test
  def dir = __dir__

  def test_shapes
    window.wh! 400, 200

    ellipse! xy: 50, wh: 100, fill: :red
    rectangle! x: 150, y: 50, wh: 100, fill: :green
    shape! x: 250, y: 50, wh: 100, fill: :blue do |w, h|
      xy! 0, h
      line! w / 2, 0
      line! w, h
    end

    assert_png
  end

  def test_enter
    window.wh! 400, 250
    layout! :xcc
    mi! 10

    label! "Enter name:"
    n = note! w: 100, content: "world"
    button! "Submit", suit: :orange do
      on_click do
        puts "Hello #{n}!"
      end
    end

    assert_png
  end

  def test_decision
    layout! :ycc
    
    space! w: 100, layout: :ysc do
      radio! do
        item! "yes", checked: true
        item! "no"
        item! "perhaps"
      end
      space! wh: 5
      button! "Submit", w: 1r do
        on_click do
          application.return d?(:item!, :checked?).subject
        end
      end
    end

    assert_png
  end

end