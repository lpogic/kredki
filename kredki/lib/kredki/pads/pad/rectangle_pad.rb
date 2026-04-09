module Kredki
  module Pads
    # Pad with rectangle area.
    class RectanglePad < ShapePad

      # Set X start Y start corner.
      def set_corner_ss corner_ss = @area.corner_ss, clip: :auto
        return send_bundle :set_corner_ss, yield(self.corner_ss) if block_given?
        @area.set_corner_ss(corner_ss) | 
        if clip == :auto
          @clip_area.set_corner_ss corner_ss - (@margin_xs + @margin_ys) * 0.5
        elsif clip
          @clip_area.set_corner_ss clip
        end
      end
      
      # See #set_corner_ss.
      def corner_ss= param
        send_bundle :set_corner_ss, param
      end
      
      # Get X start Y start corner.
      def corner_ss
        @area.corner_ss
      end

      # Set X end Y start corner.
      def set_corner_es corner_es = @area.corner_es, clip: :auto
        return send_bundle :set_corner_es, yield(self.corner_es) if block_given?
        @area.set_corner_es(corner_es) | 
        if clip == :auto
          @clip_area.set_corner_es corner_es - (@margin_xe + @margin_ys) * 0.5
        elsif clip
          @clip_area.set_corner_es clip
        end
      end
      
      # See #set_corner_es.
      def corner_es= param
        send_bundle :set_corner_es, param
      end
      
      # Get X end Y start corner.
      def corner_es
        @area.corner_es
      end

      # Set X start Y end corner.
      def set_corner_se corner_se = @area.corner_se, clip: :auto
        return send_bundle :set_corner_se, yield(self.corner_se) if block_given?
        @area.set_corner_se(corner_se) | 
        if clip == :auto
          @clip_area.set_corner_se corner_se - (@margin_xs + @margin_ye) * 0.5
        elsif clip
          @clip_area.set_corner_se clip
        end
      end
      
      # See #set_corner_se.
      def corner_se= param
        send_bundle :set_corner_se, param
      end
      
      # Get X start Y end corner.
      def corner_se
        @area.corner_se
      end

      # Set X end Y end corner.
      def set_corner_ee corner_ee = @area.corner_ee, clip: :auto
        return send_bundle :set_corner_ee, yield(self.corner_ee) if block_given?
        @area.set_corner_ee(corner_ee) | 
        if clip == :auto
          @clip_area.set_corner_ee corner_ee - (@margin_xe + @margin_ye) * 0.5
        elsif clip
          @clip_area.set_corner_ee clip
        end
      end
      
      # See #set_corner_ee.
      def corner_ee= param
        send_bundle :set_corner_ee, param
      end
      
      # Get X end Y end corner.
      def corner_ee
        @area.corner_ee
      end

      # Set X start corners.
      def set_corner_xs corner_ss = @area.corner_ss, corner_se = corner_ss, clip: :auto
        return send_bundle :set_corner_xs, yield(self.corner_xs) if block_given?
        set_corner_ss(corner_ss, clip: clip) | set_corner_se(corner_se, clip: clip)
      end
      
      # See #set_corner_xs.
      def corner_xs= param
        send_bundle :set_corner_xs, param
      end
      
      # Get X start corners.
      def corner_xs
        [corner_ss, corner_se]
      end

      # Set X end corners.
      def set_corner_xe corner_es = @area.corner_es, corner_ee = corner_es, clip: :auto
        return send_bundle :set_corner_xe, yield(self.corner_xe) if block_given?
        set_corner_es(corner_es, clip: clip) | set_corner_ee(corner_ee, clip: clip)
      end
      
      # See #set_corner_xe.
      def corner_xe= param
        send_bundle :set_corner_xe, param
      end
      
      # Get X end corners.
      def corner_xe
        [corner_es, corner_ee]
      end

      # Set Y start corners.
      def set_corner_ys corner_ss = @area.corner_ss, corner_es = corner_ss, clip: :auto
        return send_bundle :set_corner_ys, yield(self.corner_ys) if block_given?
        set_corner_ss(corner_ss, clip: clip) | set_corner_es(corner_es, clip: clip)
      end
      
      # See #set_corner_ys.
      def corner_ys= param
        send_bundle :set_corner_ys, param
      end
      
      # Get Y start corners.
      def corner_ys
        [corner_ss, corner_es]
      end

      # Set Y end corners.
      def set_corner_ye corner_se = @area.corner_se, corner_ee = corner_se, clip: :auto
        return send_bundle :set_corner_ye, yield(self.corner_ye) if block_given?
        set_corner_se(corner_se, clip: clip) | set_corner_ee(corner_ee, clip: clip)
      end
      
      # See #set_corner_ye.
      def corner_ye= param
        send_bundle :set_corner_ye, param
      end
      
      # Get Y end corners.
      def corner_ye
        [corner_se, corner_ee]
      end

      # Set corners.
      def set_corner corner_ss = @area.corner_ss, corner_es = corner_ss, corner_se = corner_ss, corner_ee = corner_es, clip: :auto, **ka
        return send_bundle :set_corner, yield(self.corner) if block_given?
        set_corner_ss(corner_ss, clip: clip) | 
        set_corner_es(corner_es, clip: clip) |
        set_corner_se(corner_se, clip: clip) |
        set_corner_ee(corner_ee, clip: clip) |
        send_branch(__method__, ka)
      end
      
      # See #set_corner.
      def corner= param
        send_bundle :set_corner, param
      end
      
      # Get corners.
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