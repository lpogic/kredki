require_relative 'basic'

module Kredki
  module UI
    module Layout
      class Way < Basic
        model :<, :space

        def tune *a
          @space == a[0] ? self : self.class.new(@x, @y, a[0])
        end

        def spans pad, pd
          ad = 0
          sd = 0
          total_span = 0
          span_pads = pad.layout_pads.map do
            span = get_span it, pd
            sd += span[1] if span[0] == 0
            ad += span[1]
            total_span += span[0]
            span
          end
          span_pads_size = span_pads.size
          return if span_pads_size < 1
          sd += @space * (span_pads_size - 1) if @space

          rd = pd - sd
          if total_span > 0 && rd > 0
            nd = rd / total_span
            rd = 0
            span_pads.each do |span|
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
                total_span = span_pads.map{ it[3] < it[2] ? it[0] : 0 }.sum
                break if total_span == 0
                nd = rd / total_span
                rd = 0
                span_pads.each do |span|
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
                total_span = span_pads.map{ it[3] > it[1] ? it[0] : 0 }.sum
                break if total_span == 0
                nd = rd / total_span
                rd = 0
                span_pads.each do |span|
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

            ad = span_pads.map{ it[3] }.sum
          end
          [ad, span_pads]
        end
        
      end#Way
    end#Layout
  end#UI
end#Kredki