module Kredki
  module Pads
    module Accordion
      class YAccordionLayout < Layout::YWay

        def determine_size_characteristics size_characteristics, lower_size, spacer
          total_size = super

          if total_size > lower_size
            enum = size_characteristics.reverse_each
            begin
              enum.next
              loop do
                characteristic = enum.next
                oversize = total_size - lower_size
                limit = characteristic.pad.size_y_limit
                min = case limit
                when Range
                  limit.begin&.then{|it| characteristic.pad.get_size_y_value it, lower_size, nil } || 0
                else
                  0
                end.floor
                margin = characteristic.size - min
                if oversize > margin
                  characteristic.size = min
                  total_size -= margin
                else
                  characteristic.size -= oversize
                  break
                end
              end
            rescue StopIteration
            end
          end

          total_size
        end
        
        def arrange pad
          csx, csy = pad.clip_size
          spacer = pad.layout_spacer || 0
          layoutic_pads = pad.layoutic_pads
          
          layoutic_pads.last&.set_size_y Auto
          pad_size_characteristics = layoutic_pads.map{|it| get_size_characteristic it, it.size_y, it.size_y_limit, csy }
          total_size_y = determine_size_characteristics pad_size_characteristics, csy, spacer
                    
          pad_size_characteristics.each do |it|
            layoutic_pad = it.pad
            sy = it.size
            sx = layoutic_pad.get_size_x csx, sy
            layoutic_pad.update_size sx, sy
          end

          arrange_pads pad.arranged_pads, total_size_y, csx, csy, spacer
        end

        def arrange_pads pads, sy, csx, csy, spacer
          cy = start_crd @y, csy, sy
          lx = lxm = ly = lym = 0

          handles = []
          
          pads.each do |p1|
            if p1.layoutic
              psx, psy, px, py = arrange_layoutic p1, csx, csy, cy
              handles.push py + psy + spacer / 2
              cy += psy + spacer
              lx = [lx, px].min
              ly = [ly, py].min
              lxm = [lxm, px + psx].max
              lym = [lym, py + psy].max
            end
          end

          each = handles.each
          pads.each do |p1|
            if !p1.layoutic
              arrange_non_layoutic p1, csx, each.next
            end
          end

          [lx, ly, lxm - lx, lym - ly]
        end

      end
    end
  end
end