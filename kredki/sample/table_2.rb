require 'kredki'

table! w: 3/4r do
  fill! :black
  m! 1, i: 1
  column! 100 # constant width 100px
  column! 2r # dynamic width (weight 2), minimum width: 0, maximum width: unlimited
  column! 1r, limit: Fit..; # dynamic width (weight 1), minimum width: fit content, maximum width: unlimited

  c = {fill: :black}

  row! do
    cell!(layout: :zec).text! "Header 1", **c
    cell!(layout: :zsc).text! "Header 2", **c
    cell!.text! "Header 3", c
  end

  scroll_rows! do
    (0..10).each do |i|
      row! fill: :green do
        cell!.text! "Cell/#{i}/1", **c
        cell!.text! "Cell/#{i}/2", **c
        cell!.text! "Cell/#{i}/3", **c
      end
    end
  end

  row! do
    cell!.text! "Footer 1", **c
    cell!.text! "Footer 2", **c
    cell!.text! "Footer 3", **c
  end
end