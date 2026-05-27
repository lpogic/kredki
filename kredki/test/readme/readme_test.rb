require 'kredki/test'

class HelloTest < Kredki::Test
  def dir = __dir__

  def test_shapes
    window.set_size 400, 200

    ellipse! xy: 50, size: 100, fill: :red
    rectangle! x: 150, y: 50, size: 100, fill: :green
    shape! x: 250, y: 50, size: 100, fill: :blue do |sx, sy|
      jump 0, sy
      line sx / 2, 0
      line sx, sy
    end

    assert_png
  end

  def test_enter
    window.set_size 400, 150
    set layout: [:xcc, 10]

    label! "Enter name:"
    note! size_x: 100, text: "world"
    button! "Submit", suit: :orange do
      on_click do
        puts "Hello #{ pane.note?.text }!"
      end
    end

    assert_png
  end

  def test_decision
    ysc! size_x: 100 do
      radio! do
        item! "yes", selected: true
        item! "no"
        item! "perhaps"
      end
      space! size: 5
      button! "Submit", size_x: 1r
    end

    self[:button!].on_click{ application.return self[:item!, selected: true].subject }

    assert_png
  end

end