module Kredki
  module UI
    class ImagePad < Pad
      extend Forwardable
      extend HasParams

      param def source! source
        @picture.source! source, false
      end, def source
        @picture.source
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

      def initialize
        super
        @picture = @scene.picture! wh: [sw, sh]
      end

      def sketch p0
        super
        @area.hide!
      end

      def set_size w, h
        super
        @picture.wh! w, h
      end

    end
  end
end