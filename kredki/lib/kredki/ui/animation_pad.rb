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

    end
  end
end