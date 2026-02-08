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

xss! m: 10, mi: 10 do
  yss! mi: 10 do
    note! w: 1r
    list! w: 1r, h: Fit do
      item! "First"
      item! "Second"
      item! "Third"
    end
    xss! mi: 10 do
      yslide!
      yss! mi: 10 do
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
    scroll! wh: [1r, limit: Fit] do
      picture! "#{Kredki.dir}/sample/stuff/test.png"
    end
  end
  yss! w: 1/2r, mi: 10 do
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
    exploding_star = "#{Kredki.dir}/sample/stuff/1643-exploding-star.json"
    animation! exploding_star, wh: [1r, limit: :ratio], x: Center do
      job.animate self, true
    end
  end
end
