require 'forwardable'

module Kredki
  module UI
    class ImagePad < Pad
      extend Forwardable

      aliasing def source! source
        @picture.source! source
        wh! *@picture.wh
      end, :source=

      def_delegators :@picture,
        :s, :source

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

        @picture = @scene.picture! clip!: @area

        @area.hide!
      end

    end
  end
end