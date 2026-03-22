module Kredki
  module Pads
    # Pad with glyph area.
    class GlyphPad < PicturePad

      # Set subject.
      def set_subject subject = @subject
        return send_bundle :set_subject, yield(self.subject) if block_given?
        return if @subject == subject && subject != :random
        if update_subject Kredki.glyph(subject)
          update_color @color if @color
        end
        @subject = subject
        true
      end

      # Set fill.
      def set_fill *fill
        return send_bundle :set_fill, yield(self.fill) if block_given?
        fill = Util.uncover fill
        return if @fill == fill && fill != :random
        update_color Kredki.color fill
        @fill = fill
        true
      end

      # See #set_fill.
      def fill= param
        send_bundle :set_fill, param
      end

      # Get fill.
      def fill
        @fill
      end

      # Set a feature recognized by its class.
      def << arg
        case arg
        when Symbol
          set_subject arg if arg =~ /^[a-z_0-9]+$/
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

        set_size Kredki.text_size
      end

      def update_color color
        @color = color
        @area.each_shape do |shape|
          Pastele.shape_set_fill_color shape.pointer, *color
        end
        @area.update
      end
    end
  end
end