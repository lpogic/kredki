require 'kredki/test'

class PadTest < Kredki::Test
  def dir = __dir__

  def test_basic
    pad! size_x: 100, size_y: 1/2r, fill: :yellow, corner: [10, ee: 30] do
      set_stroke 15, :red, cap: :round, pattern: [10, 20], behind: true
      set_turn 1/4r
      set_zoom 3/4r
    end
    assert_png
  end

  def test_clip
    pad! fill: :white, turn: 1/5r do
      set_area do |sx, sy|
        ellipse! sx, sy
      end
      pad! fill: :black, size: 4/5r
    end
    assert_png
  end

  def test_button
    button! "TEST", suit: :green, margin_x: 20
    assert_png
  end

end