require 'kredki'

table! w: 3/4r do
  fill! :black
  m! 2
  column! 1r, limit: :fit..;
  column! 2r
  column! 100
  gap! 2

  c = {fill: :black}

  row! do
    cell!(layout: :zec).text! "Header 1", c
    cell!(layout: :zsc).text! "Header 2", c
    cell!.text! "Header 3", c
  end

  scroll_rows! do
    (0..10).each do |i|
      row! fill: :green do
        cell!.text! "Cell/#{i}/1", c
        cell!.text! "Cell/#{i}/2", c
        cell!.text! "Cell/#{i}/3", c
      end
    end
  end

  row! do
    cell!.text! "Footer 1", c
    cell!.text! "Footer 2", c
    cell!.text! "Footer 3", c
  end
end