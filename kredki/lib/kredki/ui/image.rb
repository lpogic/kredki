require 'forwardable'

module Kredki
  module UI
    class Image < Pad
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

        @picture = picture! do
          clip! p0.body
        end

        @body.hide!
      end

    end
  end
end