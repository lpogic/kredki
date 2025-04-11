require 'forwardable'

module Kredki
  module UI
    class ImagePad < Pad
      extend Forwardable

      param def source! source
        @area.source! source, false
      end, get: def source
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

      def sketch p0
        super

        area! @scene.picture! wh: [sw, sh]
      end

    end
  end
end