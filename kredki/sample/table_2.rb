require 'kredki'

table! size: [3/4r, y_limit: 400] do
  fill! :black
  margin! 1
  spacer! 1

  column! 100 # constant width 100px
  column! 2r # dynamic width (weight 2), minimum width: 0, maximum width: Unlimited
  column! 1r, limit: Fit..; # dynamic width (weight 1), minimum width: Fit content, maximum width: Unlimited

  text_fill = {fill: :black}

  row! do
    cell!(layout: :zec).text! "Header 1", text_fill
    cell!(layout: :zsc).text! "Header 2", text_fill
    cell!.text! "Header 3", text_fill
  end

  scroll_rows! do
    (0..20).each do |i|
      row! fill: :green do
        cell!.text! "Cell/#{i}/1", text_fill
        cell!.text! "Cell/#{i}/2", text_fill
        cell!.text! "Cell/#{i}/3", text_fill
      end
    end
  end

  row! do
    cell!.text! "Footer 1", text_fill
    cell!.text! "Footer 2", text_fill
    cell!.text! "Footer 3", text_fill
  end
end
