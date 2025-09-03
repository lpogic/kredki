require 'kredki'

table! w: 3/4r do
  color! :black
  m! 2
  column! Fit.., 1r
  column! 2r
  column! 100
  gap! 2

  c = {color: :black}

  row! do
    cell!(layout: End/Center).text! "Header 1", c
    cell!(layout: Begin/Center).text! "Header 2", c
    cell!.text! "Header 3", c
  end

  scroll_rows! do
    (0..10).each do |i|
      row! color: :green do
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