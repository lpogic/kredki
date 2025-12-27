module Kredki
  module UI
    # Pad with animation area.
    class AnimationPad < Pad

      # Set animation content.
      def content! ...
        @area.content!(...)
      end

      # See #content!.
      def content= param
        send_ahp :content!, param
      end

      # Get animation content.
      def content
        @area.content
      end

      # Run animation in given play mode.
      def play! ...
        @area.play!(...)
      end

      # See: #play!
      def play= param
        send_ahp :play!, param
      end

      # Get running play mode.
      def play
        @area.play
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
        @area = @scene.animation!
      end

      def min_wv m
        case @w
        when :ratio
          get_h * @area.picture.aspect_ratio
        else super
        end
      end

      def min_wl m
        case @w_limit
        when :ratio
          get_h * @area.picture.aspect_ratio
        else super
        end
      end

      def get_wv w, tw, h = nil
        case w
        when :ratio
          if @ratio
            h ||= get_hv @h, nil
          else
            @ratio = true
            h ||= get_h
            @ratio = false
          end
          h * @area.picture.aspect_ratio
        else super
        end
      end

      def min_hv m
        case @h
        when :ratio
          get_w / @area.picture.aspect_ratio
        else super
        end
      end

      def min_hl m
        case @h_limit
        when :ratio
          get_w / @area.picture.aspect_ratio
        else super
        end
      end

      def get_hv h, th, w = nil
        case h
        when :ratio
          if @ratio
            w ||= get_wv @w, nil
          else
            @ratio = true
            w ||= get_w
            @ratio = false
          end
          w / @area.picture.aspect_ratio
        else super
        end
      end
    end
  end
end