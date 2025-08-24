module Kredki
  module UI
    class ImagePad < Pad
      extend Forwardable
      extend HasParams

      param def source! source
        @area.source! source, false
      end, def source
        @area.source
      end

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
        @area = @scene.picture! wh: [@w, @h]
      end
    end
  end
end