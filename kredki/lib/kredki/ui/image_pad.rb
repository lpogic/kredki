module Kredki
  module UI
    class ImagePad < Pad

      feature def content! content = nil
        return send_ahp :content!, yield(self.content) if block_given?
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

      # :section: LEVEL 2

      def initialize_area
        @area = @scene.picture! wh: [@w, @h]
      end
    end
  end
end