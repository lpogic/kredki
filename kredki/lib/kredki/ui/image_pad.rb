module Kredki
  module UI
    class ImagePad < Pad

      param def content! content = nil
        return content! (yield self.content) if block_given?
        @area.content! content, false
      end, def content
        @area.content
      end

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
        @area = @scene.picture! wh: [@w, @h]
      end
    end
  end
end