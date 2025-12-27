module Kredki
  module UI
    # Pad with picture area.
    class PicturePad < Pad

      # Set picture content.
      def content! content = @area.content
        return send_ahp :content!, yield(self.content) if block_given?
        @area.content! content, @w == :layout && @h == :layout
      end
      
      # See #content!.
      def content= param
        send_ahp :content!, param
      end

      # Get picture content.
      def content
        @area.content
      end

      # Push the feature.
      def << arg
        case arg
        when String
          content! arg
        else
          super
        end
      end

      # :section: LEVEL 2

      def initialize_area
        @area = @scene.picture!
      end

      def min_wv m
        case @w
        when :ratio
          get_h * @area.aspect_ratio
        else super
        end
      end

      def min_wl m
        case @w_limit
        when :ratio
          get_h * @area.aspect_ratio
        else super
        end
      end

      def get_wv w, tw, h = nil
        case w
        when :ratio
          if @ratio
            @area.w
          else
            @ratio = true
            h ||= get_h
            @ratio = false
            h * @area.aspect_ratio
          end
        else super
        end
      end

      def min_hv m
        case @h
        when :ratio
          get_w / @area.aspect_ratio
        else super
        end
      end

      def min_hl m
        case @h_limit
        when :ratio
          get_w / @area.aspect_ratio
        else super
        end
      end

      def get_hv h, th, w = nil
        case h
        when :ratio
          if @ratio
            @area.w
          else
            @ratio = true
            w ||= get_w
            @ratio = false
            w / @area.aspect_ratio
          end
        else super
        end
      end
    end
  end
end