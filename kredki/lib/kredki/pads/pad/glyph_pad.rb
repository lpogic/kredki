module Kredki
  module Pads
    # Pad with glyph area.
    class GlyphPad < PicturePad

      # Set subject.
      def subject! subject = @subject
        return send_bundle :subject!, yield(self.subject) if block_given?
        return if @subject == subject && subject != :random
        if set_subject Kredki.glyph(subject)
          set_color @color if @color
        end
        @subject = subject
        true
      end

      # Set fill.
      def fill! *fill
        return send_bundle :fill!, yield(self.fill) if block_given?
        fill = Util.uncover fill
        return if @fill == fill && fill != :random
        set_color Kredki.color fill
        @fill = fill
        true
      end

      # See #fill!.
      def fill= param
        send_bundle :fill!, param
      end

      # Get fill.
      def fill
        @fill
      end

      # Push the feature.
      def << arg
        case arg
        when Symbol
          subject! arg if arg =~ /^[a-z_0-9]+$/
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

        size! Kredki.text_size
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