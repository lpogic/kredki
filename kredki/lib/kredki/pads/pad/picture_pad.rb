module Kredki
  module Pads
    # Pad with picture area.
    class PicturePad < Pad

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
          set_subject arg
        else
          super
        end
      end

      # :section: LEVEL 2

      def initialize_area
        @area = @scene.picture!
      end

      def min_size_x_value margin
        case @size_x
        when Ratio
          get_size_y * @area.aspect_ratio
        else super
        end
      end

      def update_subject subject
        @area.set_content subject, @size_x == Auto && @size_y == Auto
      end

      def min_size_x_limit limit, margin
        case limit
        when Ratio
          get_size_y * @area.aspect_ratio
        else super
        end
      end

      def get_size_x_value size_x, reference_size_x, size_y
        case size_x
        when Ratio
          if @ratio
            size_y ||= @area.original_size[1]
          else
            @ratio = true
            size_y ||= get_size_y
            @ratio = false
          end
          size_y * @area.aspect_ratio
        else super
        end
      end

      def min_size_y_value margin
        case @size_y
        when Ratio
          get_size_x / @area.aspect_ratio
        else super
        end
      end

      def min_size_y_limit limit, margin
        case limit
        when Ratio
          get_size_x / @area.aspect_ratio
        else super
        end
      end

      def get_size_y_value size_y, reference_size_y, size_x
        case size_y
        when Ratio
          if @ratio
            size_x ||= @area.original_size[0]
          else
            @ratio = true
            size_x ||= get_size_x
            @ratio = false
          end
          size_x / @area.aspect_ratio
        else super
        end
      end
    end
  end
end