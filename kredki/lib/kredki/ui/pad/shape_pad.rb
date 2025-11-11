module Kredki
  module UI
    class ShapePad < Pad
      extend PadInherited

      param_delegate :@area,
        :fill,
        :out,
        :out_w,
        :out_fill, 
        :out_join, 
        :out_cap,
        :out_pattern,
        :out_trim,
        :out_behind

      [:crbb, :creb, :crbe, :cree, :crxb, :crxe, :cryb, :crye, :cr].each do |n|
        class_eval <<~RUBY
          param def #{n}! cr = nil, cr_clip = true
            return #{n}! (yield self.#{n}) if block_given?
            change = false
            change = @area.#{n}! cr if cr
            if cr_clip == true
              crcbb = cr - (@mxb + @myb) * 0.5
              crcbe = cr - (@mxb + @mye) * 0.5
              crceb = cr - (@mxe + @myb) * 0.5
              crcee = cr - (@mxe + @mye) * 0.5
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

      # internal api

      def initialize_area
        @area = @scene.rectangle!
      end
    end
  end
end