module Kredki
  module Pads
    # Pad with glyph area.
    class GlyphPad < PicturePad

      def mixed_set feature
        case feature
        when Symbol
          set_subject feature if feature =~ /^[a-z_0-9]+$/
          super
        else
          super
        end
      end

      def set_subject subject = @subject
        return if @subject == subject && subject != :random
        if update_subject Kredki.glyph(subject)
          update_color if @fill
        end
        @subject = subject
        true
      end

      feature :fill

      def set_fill *fill
        fill = Util.uncover fill
        return if @fill == fill && fill != :random
        @fill = fill
        update_color
        true
      end

      def fill
        @fill
      end

      # :section: LEVEL 2

      def initialize ...
        super

        @fill = nil
      end

      def sketch
        super

        set_size Kredki.text_size
      end

      def update_color
        color = Kredki.color @fill
        @area.each_shape do |shape|
          Pastele.shape_set_fill_color shape.pointer, *color
        end
        @area.update
      end
    end
  end
end