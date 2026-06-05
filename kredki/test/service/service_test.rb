require 'kredki/test'

class ServiceTest < Kredki::Test
  def dir = __dir__

  def test_trace
    pad! :x do
      pad! :color, :a do
        pad! :color, :b do
        end
        space! 10
        pad! :color, :c do
        end
      end
    end

    pad! :x1 do
      pad! :color, :a1 do
        pad! :color, :b1, fill: :green do
        end
        space! 10
        pad! :color, :c1 do
        end
      end
    end
    
    assert pane[:b].tags[:color]
    x = pane[:x]
    assert x[A - :b] == nil
    assert x[A + :b] != nil
    assert x[A - :a - :b] != nil
    assert pane[A + A[:color, fill: :green]].tags[:b1]
    assert pane[A + A[:color]{|it| it.lower :color }, reverse: true].tags[:c1]
  end

end