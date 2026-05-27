require_relative 'way'

module Kredki
  module Pads
    module Layout
      # A layout in which elements are positioned one next to another, along the Y axis.
      class YWay < Way

        # :section: LEVEL 2

        def get_size_characteristic pad, size_y, limit, lower_clip_size_y
          case size_y
          when Rational
            case limit
            when nil
              PadSizeCharacteristic.new pad, size_y, 0, Float::INFINITY, 0
            when Range
              syv = limit.begin&.then{|it| pad.get_size_y_value it, lower_clip_size_y, nil } || 0
              limit_syv = limit.end&.then{|it| pad.get_size_y_value it, lower_clip_size_y, nil } || Float::INFINITY
              PadSizeCharacteristic.new pad, size_y, syv, limit_syv, syv
            else
              limit_syv = pad.get_size_y_value limit, lower_clip_size_y, nil
              PadSizeCharacteristic.new pad, size_y, 0, limit_syv, 0
            end
          when Auto
            case limit
            when nil
              PadSizeCharacteristic.new pad, 1r, 0, Float::INFINITY, 0
            when Range
              syv = limit.begin&.then{|it| pad.get_size_y_value it, lower_clip_size_y, nil } || 0
              limit_syv = limit.end&.then{|it| pad.get_size_y_value it, lower_clip_size_y, nil } || Float::INFINITY
              PadSizeCharacteristic.new pad, 1r, syv, limit_syv, syv
            else
              limit_syv = pad.get_size_y_value limit, lower_clip_size_y, nil
              PadSizeCharacteristic.new pad, 1r, 0, limit_syv, 0
            end
          else
            syv = pad.get_size_y_limited size_y, limit, lower_clip_size_y
            PadSizeCharacteristic.new pad, 0, syv, syv, syv
          end
        end

        def arrange pad
          csx, csy = pad.clip_size
          spacer = pad.layout_spacer || 0
          pad_size_characteristics = pad.pads_layoutic.map{|it| get_size_characteristic it, it.size_y, it.size_y_limit, csy }
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
          cy = case @y
          when Start
            0
          when Center
            (csy - sy) * 0.5
          when End
            csy - sy
          when Rational 
            csy * @y
          when Proc
            @y[csy, sy]
          when Numeric
            @y
          else raise_is @y
          end

          lx = lxm = ly = lym = 0

          pads.each do |p1|
            if p1.layoutic
              psx, psy, px, py = arrange_layoutic p1, csx, csy, cy
              cy += psy + spacer
              lx = [lx, px].min
              ly = [ly, py].min
              lxm = [lxm, px + psx].max
              lym = [lym, py + psy].max
            else
              arrange_non_layoutic p1, csx, csy
            end
          end
          
          [lx, ly, lxm - lx, lym - ly]
        end

        def arrange_layoutic pad, csx, csy, cy
          asx, asy = pad.area_size
          px = pad.get_x csx, asx, (get_x @x, csx, asx)
          py = pad.get_y csy, asy, cy
          pad.update_xy px, py
          pad.update_margin
          pad.arrange
          [asx, asy, px, py]
        end
        
        def fit_size_y pad
          spacer = pad.layout_spacer || 0
          pad.pads_layoutic.map{|p1| p1.min_size_y }.reduce{ _1 + spacer + _2 } || 0
        end

        def get_size_y_rational pad, psy, p1, r
          index = pad.pads_layoutic.find_index{|it| it == p1 }
          if index
            pad_size_characteristics = pad.pads_layoutic.map{|it| get_size_characteristic it, it.size_y, it.size_y_limit, psy }
            determine_size_characteristics pad_size_characteristics, psy, pad.layout_spacer || 0
            pad_size_characteristics[index].size
          else
            r * psy
          end
        end

      end#YWay
    end#Layout
  end#Pads
end#Kredki