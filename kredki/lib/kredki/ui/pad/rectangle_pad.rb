module Kredki
  module UI
    # Pad with rectangle area.
    class RectanglePad < Pad

      # Set fill.
      def fill! ...
        @area.fill!(...)
      end

      # See #fill!.
      def fill= param
        send_ahp :fill!, param
      end

      # Get fill.
      def fill
        @area.fill
      end

      # Set outline.
      def outline! ...
        @area.outline!(...)
      end

      # See #outline!.
      def outline= param
        send_ahp :outline!, param
      end

      # Set outline width.
      def outline_w! ...
        @area.outline_w!(...)
      end

      # See #outline_w!.
      def outline_w= param
        send_ahp :outline_w!, param
      end

      # Get outline width.
      def outline_w
        @area.outline_w
      end

      # Set outline fill.
      def outline_fill! ...
        @area.outline_fill!(...)
      end

      # See #outline_fill!.
      def outline_fill= param
        send_ahp :outline_fill!, param
      end

      # Get outline fill.
      def outline_fill
        @area.outline_fill
      end
      
      # Set outline join.
      def outline_join! ...
        @area.outline_join!(...)
      end

      # See #outline_join!.
      def outline_join= param
        send_ahp :outline_join!, param
      end

      # Get outline join.
      def outline_join
        @area.outline_join
      end

      # Set outline cap.
      def outline_cap! ...
        @area.outline_cap!(...)
      end

      # See #outline_cap!.
      def outline_cap= param
        send_ahp :outline_cap!, param
      end

      # Get outline cap.
      def outline_cap
        @area.outline_cap
      end

      # Set outline dash pattern.
      def outline_pattern! ...
        @area.outline_pattern!(...)
      end

      # See #outline_pattern!.
      def outline_pattern= param
        send_ahp :outline_pattern!, param
      end

      # Get outline dash pattern.
      def outline_pattern
        @area.outline_pattern
      end

      # Set outline trim.
      def outline_trim! ...
        @area.outline_trim!(...)
      end

      # See #outline_trim!.
      def outline_trim= param
        send_ahp :outline_trim!, param
      end

      # Get outline trim.
      def outline_trim
        @area.outline_trim
      end

      # Set whether outline is behind fill.
      def outline_behind! ...
        @area.outline_behind!(...)
      end

      # See #outline_behind!.
      def outline_behind= param
        send_ahp :outline_behind!, param
      end

      # Get whether outline is behind fill.
      def outline_behind
        @area.outline_behind
      end

      # See #outline_behind.
      def outline_behind?
        @area.outline_behind?
      end

      # Set X start Y start corner.
      def corner_ss! corner_ss = @area.corner_ss, clip_corner = :auto
        return send_ahp :corner_ss!, yield(self.corner_ss) if block_given?
        @area.corner_ss!(corner_ss) | 
        if clip_corner == :auto
          @clip_area.corner_ss! corner_ss - (@mxs + @mys) * 0.5
        elsif clip_corner
          @clip_area.corner_ss! clip_corner
        end
      end
      
      # See #corner_ss!.
      def corner_ss= param
        send_ahp :corner_ss!, param
      end
      
      # Get X start Y start corner.
      def corner_ss
        @area.corner_ss
      end

      # Set X start Y start corner.
      def corner_es! corner_es = @area.corner_es, clip_corner = :auto
        return send_ahp :corner_es!, yield(self.corner_es) if block_given?
        @area.corner_es!(corner_es) | 
        if clip_corner == :auto
          @clip_area.corner_es! corner_es - (@mxe + @mys) * 0.5
        elsif clip_corner
          @clip_area.corner_es! clip_corner
        end
      end
      
      # See #corner_es!.
      def corner_es= param
        send_ahp :corner_es!, param
      end
      
      # Get X start Y start corner.
      def corner_es
        @area.corner_es
      end

      # Set X start Y start corner.
      def corner_se! corner_se = @area.corner_se, clip_corner = :auto
        return send_ahp :corner_se!, yield(self.corner_se) if block_given?
        @area.corner_se!(corner_se) | 
        if clip_corner == :auto
          @clip_area.corner_se! corner_se - (@mxs + @mye) * 0.5
        elsif clip_corner
          @clip_area.corner_se! clip_corner
        end
      end
      
      # See #corner_se!.
      def corner_se= param
        send_ahp :corner_se!, param
      end
      
      # Get X start Y start corner.
      def corner_se
        @area.corner_se
      end

      # Set X start Y start corner.
      def corner_ee! corner_ee = @area.corner_ee, clip_corner = :auto
        return send_ahp :corner_ee!, yield(self.corner_ee) if block_given?
        @area.corner_ee!(corner_ee) | 
        if clip_corner == :auto
          @clip_area.corner_ee! corner_ee - (@mxe + @mye) * 0.5
        elsif clip_corner
          @clip_area.corner_ee! clip_corner
        end
      end
      
      # See #corner_ee!.
      def corner_ee= param
        send_ahp :corner_ee!, param
      end
      
      # Get X start Y start corner.
      def corner_ee
        @area.corner_ee
      end

      # Set X start Y start corner.
      def corner_xs! corner_ss = @area.corner_ss, corner_se = corner_ss, clip_corner = :auto
        return send_ahp :corner_xs!, yield(self.corner_xs) if block_given?
        corner_ss!(corner_ss, clip_corner) | corner_se!(corner_se, clip_corner)
      end
      
      # See #corner_xs!.
      def corner_xs= param
        send_ahp :corner_xs!, param
      end
      
      # Get X start Y start corner.
      def corner_xs
        [corner_ss, corner_se]
      end

      # Set X start Y start corner.
      def corner_xe! corner_es = @area.corner_es, corner_ee = corner_es, clip_corner = :auto
        return send_ahp :corner_xe!, yield(self.corner_xe) if block_given?
        corner_es!(corner_es, clip_corner) | corner_ee!(corner_ee, clip_corner)
      end
      
      # See #corner_xe!.
      def corner_xe= param
        send_ahp :corner_xe!, param
      end
      
      # Get X start Y start corner.
      def corner_xe
        [corner_es, corner_ee]
      end

      # Set X start Y start corner.
      def corner_ys! corner_ss = @area.corner_ss, corner_es = corner_ss, clip_corner = :auto
        return send_ahp :corner_ys!, yield(self.corner_ys) if block_given?
        corner_ss!(corner_ss, clip_corner) | corner_es!(corner_es, clip_corner)
      end
      
      # See #corner_ys!.
      def corner_ys= param
        send_ahp :corner_ys!, param
      end
      
      # Get X start Y start corner.
      def corner_ys
        [corner_ss, corner_es]
      end

      # Set X start Y start corner.
      def corner_ye! corner_se = @area.corner_se, corner_ee = corner_se, clip_corner = :auto
        return send_ahp :corner_ye!, yield(self.corner_ye) if block_given?
        corner_se!(corner_se, clip_corner) | corner_ee!(corner_ee, clip_corner)
      end
      
      # See #corner_ye!.
      def corner_ye= param
        send_ahp :corner_ye!, param
      end
      
      # Get X start Y start corner.
      def corner_ye
        [corner_se, corner_ee]
      end

      # Set corner.
      def corner! corner = @area.corner_ss, clip_corner = :auto, **na
        return send_ahp :corner!, yield(self.corner) if block_given?
        corner_ss!(corner, clip_corner) | 
        corner_es!(corner, clip_corner) |
        corner_se!(corner, clip_corner) |
        corner_ee!(corner, clip_corner) |
        send_branch(:corner, na)
      end
      
      # See #corner!.
      def corner= param
        send_ahp :corner!, param
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