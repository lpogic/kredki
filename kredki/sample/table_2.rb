require 'kredki'

table! size: [3/4r, y_limit: 400] do
  set fill: :black
  set margin: 1
  set layout_spacer: 1
  set corner: 10

  column! 100 # constant width 100px
  column! 2r # dynamic width (weight 2), minimum width: 0, maximum width: Unlimited
  column! 1r, limit: Fit..; # dynamic width (weight 1), minimum width: Fit content, maximum width: Unlimited

  text_fill = {fill: :black}
  header = {fill: :yellow}
  footer = {fill: :green}

  row! do
    cell!(header, layout: :zec).text! "Header 1", text_fill
    cell!(header, layout: :zsc).text! "Header 2", text_fill
    cell!(header, layout: :zsc).text! "Header 3", text_fill
  end

  scroll_rows! do
    (0..20).each do |i|
      row! fill: :pink do
        cell!.text! "Cell/#{i}/1", text_fill
        cell!.text! "Cell/#{i}/2", text_fill
        cell!.text! "Cell/#{i}/3", text_fill
      end
    end
  end

  row! do
    cell!(footer).text! "Footer 1", text_fill
    cell!(footer).text! "Footer 2", text_fill
    cell!(footer).text! "Footer 3", text_fill
  end
end
