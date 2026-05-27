module Kredki
  module Pads
    # Pad with rectangle area.
    class RectanglePad < ShapePad

      feature :corner_ss # X start Y start corner.

      def set_corner_ss corner_ss = @area.corner_ss, clip: :auto
        @area.set_corner_ss(corner_ss) | 
        if clip == :auto
          @clip_area.set_corner_ss corner_ss - (@margin_xs + @margin_ys) * 0.5
        elsif clip
          @clip_area.set_corner_ss clip
        end
      end
      
      def corner_ss
        @area.corner_ss
      end

      feature :corner_es # X end Y start corner.
      
      def set_corner_es corner_es = @area.corner_es, clip: :auto
        @area.set_corner_es(corner_es) | 
        if clip == :auto
          @clip_area.set_corner_es corner_es - (@margin_xe + @margin_ys) * 0.5
        elsif clip
          @clip_area.set_corner_es clip
        end
      end
      
      def corner_es
        @area.corner_es
      end

      feature :corner_se # X start Y end corner.
      
      def set_corner_se corner_se = @area.corner_se, clip: :auto
        @area.set_corner_se(corner_se) | 
        if clip == :auto
          @clip_area.set_corner_se corner_se - (@margin_xs + @margin_ye) * 0.5
        elsif clip
          @clip_area.set_corner_se clip
        end
      end

      def corner_se
        @area.corner_se
      end

      feature :corner_ee # X end Y end corner.
      
      def set_corner_ee corner_ee = @area.corner_ee, clip: :auto
        @area.set_corner_ee(corner_ee) | 
        if clip == :auto
          @clip_area.set_corner_ee corner_ee - (@margin_xe + @margin_ye) * 0.5
        elsif clip
          @clip_area.set_corner_ee clip
        end
      end
      
      def corner_ee
        @area.corner_ee
      end

      feature :corner_xs # X start corners.
      
      def set_corner_xs corner_ss = @area.corner_ss, corner_se = corner_ss, clip: :auto
        set_corner_ss(corner_ss, clip: clip) | set_corner_se(corner_se, clip: clip)
      end
      
      def corner_xs
        [corner_ss, corner_se]
      end

      feature :corner_xe # X end corners.

      def set_corner_xe corner_es = @area.corner_es, corner_ee = corner_es, clip: :auto
        set_corner_es(corner_es, clip: clip) | set_corner_ee(corner_ee, clip: clip)
      end
      
      def corner_xe
        [corner_es, corner_ee]
      end

      feature :corner_ys # Y start corners.
      
      def set_corner_ys corner_ss = @area.corner_ss, corner_es = corner_ss, clip: :auto
        set_corner_ss(corner_ss, clip: clip) | set_corner_es(corner_es, clip: clip)
      end
      
      def corner_ys
        [corner_ss, corner_es]
      end

      feature :corner_ye # Y end corners.

      def set_corner_ye corner_se = @area.corner_se, corner_ee = corner_se, clip: :auto
        set_corner_se(corner_se, clip: clip) | set_corner_ee(corner_ee, clip: clip)
      end
      
      def corner_ye
        [corner_se, corner_ee]
      end

      feature :corner # Corner features nest.
      
      def set_corner corner_ss = @area.corner_ss, corner_es = corner_ss, corner_se = corner_ss, corner_ee = corner_es, clip: :auto, **ka
        set_corner_ss(corner_ss, clip: clip) | 
        set_corner_es(corner_es, clip: clip) |
        set_corner_se(corner_se, clip: clip) |
        set_corner_ee(corner_ee, clip: clip) |
        nest_set(__method__, ka)
      end
      
      def corner
        [corner_ss, corner_es, corner_se, corner_ee]
      end

      # :section: LEVEL 2

      def initialize_area
        @area = @scene.new_rectangle
      end
    end
  end
end