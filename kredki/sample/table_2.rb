require 'kredki'

table! size: [3/4r, y_limit: 400] do
  set fill: :black, margin: 1, layout_spacer: 1
  set corner: 10

  column! 100 # constant width 100px
  column! 2r # dynamic width (weight 2), minimum width: 0, maximum width: Unlimited
  column! 1r, limit: Fit..; # dynamic width (weight 1), minimum width: Fit content, maximum width: Unlimited

  text = {fill: :black}
  header = {fill: :yellow}
  footer = {fill: :green}

  row! do
    cell!(header, layout: :zec).text! text, "Header 1"
    cell!(header, layout: :zsc).text! text, "Header 2"
    cell!(header, layout: :zsc).text! text, "Header 3"
  end

  scroll_rows! do
    (0..20).each do |i|
      row! fill: :pink do
        cell!.text! text, "Cell/#{i}/1"
        cell!.text! text, "Cell/#{i}/2"
        cell!.text! text, "Cell/#{i}/3"
      end
    end
  end

  row! do
    cell!(footer).text! text, "Footer 1"
    cell!(footer).text! text, "Footer 2"
    cell!(footer).text! text, "Footer 3"
  end
end
