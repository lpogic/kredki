module Kredki
  module UI
    class AnimationPad < Pad

      feature_delegate :@area,
        :content, :play

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