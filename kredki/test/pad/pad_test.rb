require 'kredki/test'

class PadTest < Kredki::Test
  def dir = __dir__

  def test_basic
    p name
    pad! w: 100, h: 1/2r, fill: :yellow, corner: [10, ee: 30] do
      outline! 15, :red, cap: :round, pattern: [10, 20], behind: true
      rot! 1/4r
      mag! 3/4r
    end
    assert_png
  end

  def test_clip
    pad! fill: :white, rot: 1/5r do
      area! do |w, h|
        ellipse! w, h
      end
      pad! fill: :black, wh: 4/5r
    end
    assert_png
  end

  def test_button
    button! "TEST", suit: :green, margin_x: 20
    assert_png
  end

end