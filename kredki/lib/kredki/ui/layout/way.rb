module Kredki
  module UI
    module Layout
      class Way
        include Layout

        def spans sp, pd, space
          ad = 0
          sd = 0
          total_span = 0
          sp.each do |span|
            sd += span[1] if span[0] == 0
            ad += span[1]
            total_span += span[0]
          end
          return if sp.empty?
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
                total_span = sp.map{ it[3] < it[2] ? it[0] : 0 }.sum
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
                total_span = sp.map{ it[3] > it[1] ? it[0] : 0 }.sum
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
            
            return [m = sp.map{ it[3] }, m.sum + total_space]
          end
          [sp.map{ it[3] }, ad + total_space]
        end

        def arrange_non_layoutic pad, cw, ch
          pw = get_w pad, pad.w, cw
          ph = get_h pad, pad.h, ch
          pad.set_size pw, ph
          px = pad.get_x cw, pw, (get_x @x, cw, pw)
          py = pad.get_y ch, ph, (get_y @y, ch, ph)
          pad.set_xy px, py
          pad.set_margin
          pad.arrange
        end
        
      end#Way
    end#Layout
  end#UI
end#Kredki