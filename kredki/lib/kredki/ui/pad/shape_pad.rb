module Kredki
  module UI
    class ShapePad < Pad
      include PadBase
      include Alterable
      include LocalMedia
      include PadEvents
      extend Forwardable
      extend HasParams
      extend PadInherited

      param_prefix :stroke

      param def stroke_size! size
        @area.stroke_size! size and layer&.break_layout
      end, def stroke_size
        @area.stroke_size
      end

      param_delegate :@area, 
        :stroke_color, 
        :stroke_join, 
        :stroke_cap

      param def color! *color
        @area.fill_color = color
      end, def color
        @area.fill_color
      end

      [:rbb, :reb, :rbe, :ree, :rxb, :rxe, :ryb, :rye, :r].each do |n|
        class_eval <<~xx
          param def #{n}! r, clip = true
            change = false
            change = @area.#{n}! r if r
            if clip
              clip = r if clip == true
              change = (@clip_area.#{n}! r or change)
            end
            change
          end, def #{n} clip = false
            clip ? @clip_area.#{n} : @area.#{n}
          end
        xx
      end

      # internal api

      def initialize_area
        @area = @scene.rectangle!
      end
    end
  end
end