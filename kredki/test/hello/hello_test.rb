require 'kredki/test'

class HelloTest < Kredki::Test
  def dir = __dir__

  def test_hello
    window.wh! 400, 100
    layout! :xcc
    mi! 10

    label! "Enter your name:"
    note! :@name, w: 100, content: "World"
    button! "Submit", suit: :orange, mx: 6 do
      corner! 5
      on_click do
        puts "Hello #{window.fd(:@name).content}!"
      end
    end

    assert_png
  end

end