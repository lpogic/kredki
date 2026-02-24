module Kredki
  module Pads
    # Pad with picture area.
    class PicturePad < Pad

      # Set picture content.
      def content! content = @area.content
        return send_bundle :content!, yield(self.content) if block_given?
        @area.content! content, @w == Auto && @h == Auto
      end
      
      # See #content!.
      def content= param
        send_bundle :content!, param
      end

      # Get picture content.
      def content
        @area.content
      end

      # Find shape of the picture.
      def find_shape ...
        @area.find_shape(...)
      end

      # Traverse shape tree of the picture.
      def each_shape ...
        @area.each_shape(...)
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
        when Ratio
          get_h * @area.aspect_ratio
        else super
        end
      end

      def min_wl limit, m
        case limit
        when Ratio
          get_h * @area.aspect_ratio
        else super
        end
      end

      def get_wv w, tw, h
        case w
        when Ratio
          if @ratio
            h ||= @area.wh_origin[1]
          else
            @ratio = true
            h ||= get_h
            @ratio = false
          end
          h * @area.aspect_ratio
        else super
        end
      end

      def min_hv m
        case @h
        when Ratio
          get_w / @area.aspect_ratio
        else super
        end
      end

      def min_hl limit, m
        case limit
        when Ratio
          get_w / @area.aspect_ratio
        else super
        end
      end

      def get_hv h, th, w
        case h
        when Ratio
          if @ratio
            w ||= @area.wh_origin[0]
          else
            @ratio = true
            w ||= get_w
            @ratio = false
          end
          w / @area.aspect_ratio
        else super
        end
      end
    end
  end
end