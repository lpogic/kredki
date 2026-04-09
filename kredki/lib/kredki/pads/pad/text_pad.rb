module Kredki
  module Pads
    # Pad with text area.
    class TextPad < Pad

      # Get text content.
      def text
        @subject.to_s
      end

      # Set fill.
      def set_fill *fill
        return send_bundle :set_fill, yield(self.fill) if block_given?
        return unless @area.set_fill *fill
        @verses.each{|it| it.set_fill *fill }
        true
      end
      
      # See #set_fill.
      def fill= param
        send_bundle :set_fill, param
      end

      # Get fill.
      def fill
        @area.fill
      end

      # Set stroke features.
      def set_stroke *a, **ka
        a.map do |it|
          case it
          when Hash
            set_stroke **it
          when Numeric
            set_stroke_width it
          else
            send_bundle :set_stroke_fill, it
          end
        end.any? | send_branch(__method__, ka)
      end
      
      # See #set_stroke.
      def stroke= param
        send_bundle :set_stroke, param
      end

      # Set stroke fill.
      def set_stroke_fill *stroke_fill
        return send_bundle :set_stroke_fill, yield(self.stroke_fill) if block_given?
        return unless @area.set_stroke_fill *stroke_fill
        @verses.each{|it| it.set_stroke_fill *stroke_fill }
        true
      end

      # See #set_stroke_fill.
      def stroke_fill= param
        send_bundle :set_stroke_fill, param
      end

      # Get stroke fill.
      def stroke_fill
        @area.fill
      end

      # Set stroke width.
      def set_stroke_width stroke_width = @stroke_width
        return send_bundle :set_stroke_width, yield(self.stroke_width) if block_given?
        return unless @area.set_stroke_width *stroke_width
        @verses.each{|it| it.set_stroke_width *stroke_width }
        true
      end

      # See #set_stroke_width.
      def stroke_width= param
        send_bundle :set_stroke_width, param
      end

      # Get stroke width.
      def stroke_width
        @area.fill
      end

      # Set verse features.
      def set_verse *a, **ka
        a.map do |it|
          case it
          when Hash
            set_verse **it
          when Numeric, :auto
            set_verse_size it
          else
            set_verse_layout it
          end
        end.any? | send_branch(__method__, ka)
      end

      # See #set_verse.
      def verse= param
        send_bundle :set_verse, param
      end

      # Set verse layout.
      def set_verse_layout layout = nil
        return send_bundle :set_verse_layout, yield(self.verse_layout) if block_given?
        return if @verse_layout == layout
        @verse_layout = layout
        arrange_verses
      end

      # See #set_verse_layout.
      def verse_layout= param
        send_bundle :set_verse_layout, param
      end

      # Get verse layout.
      def verse_layout
        @verse_layout
      end

      # Set space between verses.
      def set_verse_space verse_space = @verse_space
        return send_bundle :set_verse_space, yield(self.verse_space) if block_given?
        return if @verse_space == verse_space
        @verse_space = verse_space
        layer&.break_layout
        true
      end
      
      # See #set_verse_space.
      def verse_space= param
        send_bundle :set_verse_space, param
      end
      
      # Get space between verses.
      def verse_space
        @verse_space || 0
      end

      # Set verse size.
      def set_verse_size verse_size = @verse_size
        return send_bundle :set_verse_size, yield(self.verse_size) if block_given?
        return if @verse_size == verse_size
        @verse_size = verse_size
        arrange_verses
      end

      # See #set_verse_size.
      def verse_size= param
        send_bundle :set_verse_size, param
      end

      # Get verse size.
      def verse_size
        @verse_size
      end

      # Set a feature recognized by its class.
      def << feature
        case feature
        when String
          set_subject feature
        else
          super
        end
      end

      # :section: LEVEL 2

      def initialize
        super

        @verses = []
        @verse_size = :auto
      end

      def sketch
        super

        set_size Fit
        set_verse_layout :ysc
        set_verse_size Kredki.text_size
        set_subject "TEXT"
      end

      def update_subject subject
        font = @verses.first&.font || Kredki.font
        @verses&.each{|it| it.detach }
        @verses = "#{subject}\n".each_line(chomp: true).map do |line|
          @scene.new_text line.chomp, fill: @area.fill, font: font
        end
        arrange_verses
        layer&.break_layout
      end

      def verse_metrics size_y
        case @verse_size
        when :auto
          size_v = 0
          case @verse_space
          when Rational
            size_v = size_y / (1 + (@verses.size - 1) * @verse_space) if @verses.size > 0
            space = size_v * @verse_space
          when Numeric
            size_v = (size_y + (@verses.size - 1) * @verse_space) / @verses.size if @verses.size > 0
            space = @verse_space
          when :auto
            if @verses.size > 0
              size_v = size_y / @verses.size
              space = (size_y - @verses.size * size_v) / (@verses.size - 1)
            else
              space = 0
            end
          else
            size_v = size_y / @verses.size if @verses.size > 0
            space = 0
          end
        when Rational
          size_v = @verses.size > 0 ? @verse_size * size_y : 0
          case @verse_space
          when Rational
            space = size_v * @verse_space
          when Numeric
            space = @verse_space
          when :auto
            if @verses.size > 0
              space = (size_y - @verses.size * size_v) / (@verses.size - 1)
            else
              space = 0
            end
          else
            space = 0
          end
        else
          size_v = @verses.size > 0 ? @verse_size : 0
          case @verse_space
          when Rational
            space = size_v * @verse_space
          when Numeric
            space = @verse_space
          when :auto
            if @verses.size > 0
              space = (size_y - @verses.size * size_v) / (@verses.size - 1)
            else
              space = 0
            end
          else
            space = 0
          end
        end

        [size_v, space]
      end

      def fit_size_x
        size_v, _ = verse_metrics get_size_y
        @verses.map{|it| size_v * it.size_x / it.size_y }.max
      end

      def fit_size_y
        size_v, space = verse_metrics 0
        @margin_ys + @margin_ye + (size_v + space) * @verses.size - space
      end

      def update_size x, y
        super and arrange_verses
      end

      def arrange_verses
        if @verses.size > 0
          sx, sy = area_size
          size_v, space = verse_metrics sy
          size_t = (size_v + space) * @verses.size - space
          y = align_y size_t, sy
          @verses.each do |v|
            v.set_size_y size_v
            x = align_x v.size_x, sx
            v.set_xy x, y
            y += size_v + space
          end
        end
        true
      end

      def align_x reference_size_x, size_x
        case @verse_layout
        when :yss, :ysc, :yse
          0
        when :yes, :yec, :yee
          size_x - reference_size_x
        when :ycs, :ycc, :yce
          (size_x - reference_size_x) * 0.5
        else raise_is @verse_layout
        end
      end

      def align_y reference_size_y, size_y
        case @verse_layout
        when :yss, :ycs, :yes
          0
        when :yse, :yce, :yee
          size_y - reference_size_y
        when :ysc, :ycc, :yec
          (size_y - reference_size_y) * 0.5
        else raise_is @verse_layout
        end
      end
    end
  end
end