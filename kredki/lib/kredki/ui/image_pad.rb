require 'forwardable'

module Kredki
  module UI
    class ImagePad < Pad
      extend Forwardable

      aliasing def s! source
        @picture.s! source
        wh! *@picture.wh
      end, :s=, :source!, :source=

      def_delegators :@picture,
        :s, :source

      def << arg
        case arg
        when String
          s! arg
        else
          super
        end
      end

      #internal api

      def sketch p0
        super

        @picture = @scene.picture! clip!: @body

        @body.hide!
      end

    end
  end
end