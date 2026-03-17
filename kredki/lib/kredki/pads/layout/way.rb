module Kredki
  module Pads
    module Layout
      # A layout in which elements are positioned one next to another.
      class Way
        include Layout

        # :section: LEVEL 2

        def spans sp, pd, space
          ad = 0
          sd = 0
          total_span = 0
          sp.each do |span|
            sd += span[1] if span[0] == 0
            ad += span[1]
            total_span += span[0]
          end
          return [[], 0] if sp.empty?
          total_space = space * (sp.size - 1)
          sd += total_space

          rd = pd - sd
          if total_span > 0 && rd > 0
            nd = rd / total_span
            rd = 0
            sp.each do |span|
              if span[0] > 0
                od = nd * span[0]
                if od > span[2]
                  span[3] = span[2]
                  rd += od - span[2]
                elsif od < span[1]
                  span[3] = span[1]
                  rd += od - span[1]
                else
                  span[3] = od
                end
              end
            end

            loop do
              if rd > 0
                total_span = sp.map{|it| it[3] < it[2] ? it[0] : 0 }.sum
                break if total_span == 0
                nd = rd / total_span
                rd = 0
                sp.each do |span|
                  if span[3] < span[2]
                    od = nd * span[0] + span[3]
                    if od > span[2]
                      span[3] = span[2]
                      rd += od - span[2]
                    else
                      span[3] = od
                    end
                  end
                end
              elsif rd < 0
                total_span = sp.map{|it| it[3] > it[1] ? it[0] : 0 }.sum
                break if total_span == 0
                nd = rd / total_span
                rd = 0
                sp.each do |span|
                  if span[3] > span[1]
                    od = nd * span[0] + span[3]
                    if od < span[1]
                      span[3] = span[1]
                      rd += od - span[1]
                    else
                      span[3] = od
                    end
                  end
                end
              else
                break
              end
            end
            
            return [m = sp.map{|it| it[3] }, m.sum + total_space]
          end
          [sp.map{|it| it[3] }, ad + total_space]
        end

        def arrange_non_layoutic pad, csx, csy
          psx = pad.get_size_x csx
          psy = pad.get_size_y csy
          pad.update_size psx, psy
          px = pad.get_x csx, psx, (get_x @x, csx, psx)
          py = pad.get_y csy, psy, (get_y @y, csy, psy)
          pad.update_xy px, py
          pad.update_margin
          pad.arrange
        end
        
      end#Way
    end#Layout
  end#Pads
end#Kredki