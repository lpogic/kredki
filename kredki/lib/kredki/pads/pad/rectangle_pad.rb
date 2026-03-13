module Kredki
  module Pads
    # Pad with rectangle area.
    class RectanglePad < ShapePad

      # Set X start Y start corner.
      def corner_ss! corner_ss = @area.corner_ss, clip_corner = :auto
        return send_bundle :corner_ss!, yield(self.corner_ss) if block_given?
        @area.corner_ss!(corner_ss) | 
        if clip_corner == :auto
          @clip_area.corner_ss! corner_ss - (@margin_xs + @margin_ys) * 0.5
        elsif clip_corner
          @clip_area.corner_ss! clip_corner
        end
      end
      
      # See #corner_ss!.
      def corner_ss= param
        send_bundle :corner_ss!, param
      end
      
      # Get X start Y start corner.
      def corner_ss
        @area.corner_ss
      end

      # Set X start Y start corner.
      def corner_es! corner_es = @area.corner_es, clip_corner = :auto
        return send_bundle :corner_es!, yield(self.corner_es) if block_given?
        @area.corner_es!(corner_es) | 
        if clip_corner == :auto
          @clip_area.corner_es! corner_es - (@margin_xe + @margin_ys) * 0.5
        elsif clip_corner
          @clip_area.corner_es! clip_corner
        end
      end
      
      # See #corner_es!.
      def corner_es= param
        send_bundle :corner_es!, param
      end
      
      # Get X start Y start corner.
      def corner_es
        @area.corner_es
      end

      # Set X start Y start corner.
      def corner_se! corner_se = @area.corner_se, clip_corner = :auto
        return send_bundle :corner_se!, yield(self.corner_se) if block_given?
        @area.corner_se!(corner_se) | 
        if clip_corner == :auto
          @clip_area.corner_se! corner_se - (@margin_xs + @margin_ye) * 0.5
        elsif clip_corner
          @clip_area.corner_se! clip_corner
        end
      end
      
      # See #corner_se!.
      def corner_se= param
        send_bundle :corner_se!, param
      end
      
      # Get X start Y start corner.
      def corner_se
        @area.corner_se
      end

      # Set X start Y start corner.
      def corner_ee! corner_ee = @area.corner_ee, clip_corner = :auto
        return send_bundle :corner_ee!, yield(self.corner_ee) if block_given?
        @area.corner_ee!(corner_ee) | 
        if clip_corner == :auto
          @clip_area.corner_ee! corner_ee - (@margin_xe + @margin_ye) * 0.5
        elsif clip_corner
          @clip_area.corner_ee! clip_corner
        end
      end
      
      # See #corner_ee!.
      def corner_ee= param
        send_bundle :corner_ee!, param
      end
      
      # Get X start Y start corner.
      def corner_ee
        @area.corner_ee
      end

      # Set X start Y start corner.
      def corner_xs! corner_ss = @area.corner_ss, corner_se = corner_ss, clip_corner = :auto
        return send_bundle :corner_xs!, yield(self.corner_xs) if block_given?
        corner_ss!(corner_ss, clip_corner) | corner_se!(corner_se, clip_corner)
      end
      
      # See #corner_xs!.
      def corner_xs= param
        send_bundle :corner_xs!, param
      end
      
      # Get X start Y start corner.
      def corner_xs
        [corner_ss, corner_se]
      end

      # Set X start Y start corner.
      def corner_xe! corner_es = @area.corner_es, corner_ee = corner_es, clip_corner = :auto
        return send_bundle :corner_xe!, yield(self.corner_xe) if block_given?
        corner_es!(corner_es, clip_corner) | corner_ee!(corner_ee, clip_corner)
      end
      
      # See #corner_xe!.
      def corner_xe= param
        send_bundle :corner_xe!, param
      end
      
      # Get X start Y start corner.
      def corner_xe
        [corner_es, corner_ee]
      end

      # Set X start Y start corner.
      def corner_ys! corner_ss = @area.corner_ss, corner_es = corner_ss, clip_corner = :auto
        return send_bundle :corner_ys!, yield(self.corner_ys) if block_given?
        corner_ss!(corner_ss, clip_corner) | corner_es!(corner_es, clip_corner)
      end
      
      # See #corner_ys!.
      def corner_ys= param
        send_bundle :corner_ys!, param
      end
      
      # Get X start Y start corner.
      def corner_ys
        [corner_ss, corner_es]
      end

      # Set X start Y start corner.
      def corner_ye! corner_se = @area.corner_se, corner_ee = corner_se, clip_corner = :auto
        return send_bundle :corner_ye!, yield(self.corner_ye) if block_given?
        corner_se!(corner_se, clip_corner) | corner_ee!(corner_ee, clip_corner)
      end
      
      # See #corner_ye!.
      def corner_ye= param
        send_bundle :corner_ye!, param
      end
      
      # Get X start Y start corner.
      def corner_ye
        [corner_se, corner_ee]
      end

      # Set corner.
      def corner! corner = @area.corner_ss, clip_corner = :auto, **ka
        return send_bundle :corner!, yield(self.corner) if block_given?
        corner_ss!(corner, clip_corner) | 
        corner_es!(corner, clip_corner) |
        corner_se!(corner, clip_corner) |
        corner_ee!(corner, clip_corner) |
        send_branch(:corner, ka)
      end
      
      # See #corner!.
      def corner= param
        send_bundle :corner!, param
      end
      
      # Get X start Y start corner.
      def corner
        [corner_ss, corner_es, corner_se, corner_ee]
      end

      # :section: LEVEL 2

      def initialize_area
        @area = @scene.rectangle!
      end
    end
  end
end