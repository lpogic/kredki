require 'kredki/test'

class PadGalleryTest < Kredki::Test
  def dir = __dir__

  def test_pad_gallery
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

    space! layout: :xss, m: 10, mi: 10 do
      space! layout: :yss, mi: 10 do
        note! w: 1r
        list! w: 1r, h: :fit do
          item! "First"
          item! "Second"
          item! "Third"
        end
        space! layout: :xss, mi: 10 do
          yslide!
          space! layout: :yss, mi: 10 do
            text! "Some text"
            xslide!
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
        scroll! wh: [1r, limit: :fit] do
          picture! "#{Kredki.dir}/sample/stuff/test.png"
        end
      end
      space! layout: :yss, w: 1/2r, mi: 10 do
        notes! w: 1r
        option! w: 1r do
          item! "Red"
          item! "Green"
          item! "Blue"
          item! "test", subject: :test
          item! "1234", subject: 1234
        end
        check! "Check A"
        check! "Check B"
        radio! do
          item! "Radio 1"
          item! "Radio 2"
          item! "Radio 3"
        end
        animation! "#{Kredki.dir}/sample/stuff/1643-exploding-star.json", wh: [1r, limit: :ratio], x: :center do
          job.animate self, true
        end
      end
    end

    assert_png
  end

end