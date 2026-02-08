module Kredki
  module Pads
    # Pad with glyph area.
    class GlyphPad < PicturePad

      # Set content.
      def content! content = @content
        return send_ahp :content!, yield(self.content) if block_given?
        return if @content == content && content != :rand
        if @area.content! Kredki.glyph(content), @w == Auto && @h == Auto
          set_color @color if @color
        end
        @content = content
        true
      end

      # Get content.
      def content
        @content
      end

      # Set fill.
      def fill! *fill
        return send_ahp :fill!, yield(self.fill) if block_given?
        fill = Util.uncover fill
        return if @fill == fill && fill != :rand
        set_color Kredki.color fill
        @fill = fill
        true
      end

      # See #fill!.
      def fill= param
        send_ahp :fill!, param
      end

      # Get fill.
      def fill
        @fill
      end

      # Push the feature.
      def << arg
        case arg
        when Symbol
          content! arg if arg =~ /^[a-z_0-9]+$/
          super
        else
          super
        end
      end

      # :section: LEVEL 2

      def initialize ...
        super
        @fill = nil
        @color = nil
      end

      def sketch
        super

        wh! Kredki.text_size
      end

      def set_color color
        @color = color
        @area.each_shape do |shape|
          Pastele.shape_set_fill_color shape.pointer, *color
        end
        @area.update
      end
    end
  end
end