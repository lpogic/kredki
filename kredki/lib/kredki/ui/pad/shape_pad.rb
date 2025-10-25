module Kredki
  module UI
    class ShapePad < Pad
      extend Forwardable
      extend HasParams
      extend PadInherited

      param_prefix :stroke

      param def stroke_size! size = nil
        return stroke_size! (yield self.stroke_size) if block_given?
        @area.stroke_size! size and layer&.break_layout
      end, def stroke_size
        @area.stroke_size
      end

      param_delegate :@area, 
        :stroke_color, 
        :stroke_join, 
        :stroke_cap

      param def color! *color
        return color! *Util.cover(yield self.color) if block_given?
        @area.fill_color = color
      end, def color
        @area.fill_color
      end

      [:rbb, :reb, :rbe, :ree, :rxb, :rxe, :ryb, :rye, :r].each do |n|
        class_eval <<~RUBY
          param def #{n}! r = nil, r_clip = true
            return #{n}! (yield self.#{n}) if block_given?
            change = false
            change = @area.#{n}! r if r
            if r_clip == true
              rcbb = r - (@mxb + @myb) * 0.5
              rcbe = r - (@mxb + @mye) * 0.5
              rceb = r - (@mxe + @myb) * 0.5
              rcee = r - (@mxe + @mye) * 0.5
              @clip_area.r! rcbb, rceb, rcbe, rcee or change
            elsif r_clip
              @clip_area.#{n} = r_clip or change
            else
              change
            end
          end, def #{n} clip = false
            clip ? @clip_area.#{n} : @area.#{n}
          end
        RUBY
      end

      # internal api

      def initialize_area
        @area = @scene.rectangle!
      end
    end
  end
end