require 'kredki/test'

class PadGalleryTest < Kredki::Test
  def dir = __dir__

  def test_pad_gallery
    set layout: :yss

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

    context_menu! do
      item! "Cut"
      item! "Copy"
      item! "Paste"
      item! "More.." do
        item! "Find"
        item! "Replace"
      end
    end

    xss! margin: 10, spacer: 10 do
      yss! spacer: 10 do
        note! size_x: 1r
        list! size_x: 1r, size_y: Fit do
          item! "First"
          item! "Second"
          item! "Third"
        end
        xss! spacer: 10 do
          slider_y!
          yss! spacer: 10 do
            margin[5]
            text! "Some text"
            slider_x!
            button! "Button"
          end
          tree! do
            item! "Branch"
            item! "Branch" do
              item! "Branch" do
                item! "Branch"
              end
            end
          end
        end
        scroll! size: [1r, limit: Fit] do
          picture! "#{Kredki.dir}/sample/stuff/test.png"
        end
      end
      yss! size_x: 1/2r, spacer: 10 do
        notes! size_x: 1r
        option! size_x: 1r do
          item! "Red"
          item! "Green", disabled: true
          item! "Blue"
          item! "test", subject: :test
          item! "1234", subject: 1234
        end
        checkbox! "Checkbox A"
        checkbox! "Checkbox B"
        radio! do
          item! "Radio 1"
          item! "Radio 2"
          item! "Radio 3"
        end
        exploding_star = "#{Kredki.dir}/sample/stuff/1643-exploding-star.json"
        animation! exploding_star, size: [1r, limit: Ratio], x: Center do
          job.play_loop self
        end
      end
    end

    assert_png
  end

end