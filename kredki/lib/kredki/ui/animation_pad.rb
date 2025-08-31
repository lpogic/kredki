module Kredki
  module UI
    class AnimationPad < Pad
      extend Forwardable
      extend HasParams

      param_delegate :@area,
        :source, :play

      def << arg
        case arg
        when String
          source! arg
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