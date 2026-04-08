module Kredki
  module Pads
    # Pad with animation area.
    class AnimationPad < Pad

      # Set a feature recognized by its class.
      def << arg
        case arg
        when String
          set_subject arg
        else
          super
        end
      end

      def set_frame ...
        @area.set_frame(...)
      end

      def frame= param
        send_bundle :set_frame, param
      end

      def frame
        @area.frame
      end

      # Get duration.
      def duration
        @area.duration
      end

      # :section: LEVEL 2

      def initialize_area
        @area = @scene.new_animation
      end

      def update_subject subject
        @area.content = subject.to_s
      end

      def min_size_x_value m
        case @size_x
        when Ratio
          get_size_y * @area.picture.aspect_ratio
        else super
        end
      end

      def min_size_x_limit limit, m
        case limit
        when Ratio
          get_size_y * @area.picture.aspect_ratio
        else super
        end
      end

      def get_size_x_value size_x, target_size_x, size_y
        case size_x
        when Ratio
          if @ratio
            size_y ||= @area.picture.original_size[1]
          else
            @ratio = true
            size_y ||= get_size_y
            @ratio = false
          end
          size_y * @area.picture.aspect_ratio
        else super
        end
      end

      def min_size_y_value m
        case @size_y
        when Ratio
          get_size_x / @area.picture.aspect_ratio
        else super
        end
      end

      def min_size_y_limit limit, m
        case limit
        when Ratio
          get_size_x / @area.picture.aspect_ratio
        else super
        end
      end

      def get_size_y_value size_y, target_size_y, size_x
        case size_y
        when Ratio
          if @ratio
            size_x ||= @area.picture.original_size[0]
          else
            @ratio = true
            size_x ||= get_size_x
            @ratio = false
          end
          size_x / @area.picture.aspect_ratio
        else super
        end
      end
    end
  end
end