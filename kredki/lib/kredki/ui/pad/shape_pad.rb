module Kredki
  module UI
    class ShapePad < Pad
      extend PadInherited

      feature_delegate :@area,
        :fill,
        :outline,
        :outline_w,
        :outline_fill, 
        :outline_join, 
        :outline_cap,
        :outline_pattern,
        :outline_trim,
        :outline_behind

      [:crtt, :crht, :crth, :crhh, :crxt, :crxh, :cryt, :cryh, :cr].each do |n|
        class_eval <<~RUBY
          feature def #{n}! cr = nil, cr_clip = true
            return #{n}! (yield(self.#{n})) if block_given?
            change = false
            change = @area.#{n}! cr if cr
            if cr_clip == true
              crcbb = cr - (@mxt + @myt) * 0.5
              crcbe = cr - (@mxt + @myh) * 0.5
              crceb = cr - (@mxh + @myt) * 0.5
              crcee = cr - (@mxh + @myh) * 0.5
              @clip_area.cr! crcbb, crceb, crcbe, crcee or change
            elsif cr_clip
              @clip_area.#{n} = cr_clip ocr change
            else
              change
            end
          end, def #{n} clip = false
            clip ? @clip_area.#{n} : @area.#{n}
          end
        RUBY
      end

      # :section: LEVEL 2

      def initialize_area
        @area = @scene.rectangle!
      end
    end
  end
end