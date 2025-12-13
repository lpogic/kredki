module Kredki
  module UI
    # Pad with picture area.
    class PicturePad < Pad

      # Set picture content.
      def content! content = @area.content
        return send_ahp :content!, yield(self.content) if block_given?
        @area.content! content, false
      end
      
      # See #content!.
      def content= param
        send_ahp :content!, param
      end

      # Get picture content.
      def content
        @area.content
      end

      # Push the feature.
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