require 'kredki/test'

class HelloTest < Kredki::Test
  def dir = __dir__

  def test_shapes
    window.set_size 400, 200

    ellipse! xy: 50, size: 100, fill: :red
    rectangle! x: 150, y: 50, size: 100, fill: :green
    shape! x: 250, y: 50, size: 100, fill: :blue do |sx, sy|
      xy! 0, sy
      line! sx / 2, 0
      line! sx, sy
    end

    assert_png
  end

  def test_enter
    window.set_size 400, 250
    set_layout :xcc
    set_spacer 10

    label! "Enter name:"
    n = note! size_x: 100, text: "world"
    button! "Submit", suit: :orange do
      on_click do
        puts "Hello #{n}!"
      end
    end

    assert_png
  end

  def test_decision
    set layout: :ycc
    
    space! size_x: 100, layout: :ysc do
      radio! do
        item! "yes", checked: true
        item! "no"
        item! "perhaps"
      end
      space! size: 5
      button! "Submit", size_x: 1r do
        on_click do
          app.return find_upper(:item!, :checked?).subject
        end
      end
    end

    assert_png
  end

end