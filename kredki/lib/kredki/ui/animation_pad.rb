module Kredki
  module UI
    class AnimationPad < Pad

      param_delegate :@area,
        :content, :play

      def << arg
        case arg
        when String
          content! arg
        else
          super
        end
      end

      #internal api

      def initialize_area
        @area = @scene.animation!
      end

    end
  end
end