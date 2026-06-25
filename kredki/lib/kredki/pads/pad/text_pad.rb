module Kredki
  module Pads
    # Pad with text area.
    class TextPad < Pad

      def mixed_set feature
        case feature
        when String
          set_subject feature
        else
          super
        end
      end
      
      # Get text content.
      def text
        @subject.to_s
      end

      feature :fill
      
      def set_fill *fill
        return unless @area.set_fill *fill
        @verses.each{|it| it.set_fill *fill }
        true
      end
      
      def fill
        @area.fill
      end

      feature :stroke
      
      def set_stroke *a, **ka
        changes = a.count do |it|
          case it
          when Numeric
            set_stroke_width it
          else
            mixed_set_stroke_fill it
          end
        end
        nest_set(__method__, ka) || changes > 0
      end
      
      feature :stroke_fill
      
      def set_stroke_fill *stroke_fill
        return unless @area.set_stroke_fill *stroke_fill
        @verses.each{|it| it.set_stroke_fill *stroke_fill }
        true
      end

      def stroke_fill
        @area.fill
      end

      feature :stroke_width
      
      def set_stroke_width stroke_width
        return unless @area.set_stroke_width *stroke_width
        @verses.each{|it| it.set_stroke_width *stroke_width }
        true
      end

      def stroke_width
        @area.fill
      end

      feature :verse
      
      def set_verse *a, **ka
        changes = a.count do |it|
          case it
          when Numeric, :auto
            set_verse_size it
          else
            set_verse_layout it
          end
        end
        nest_set(__method__, ka) || changes > 0
      end

      feature :verse_layout
      
      def set_verse_layout layout
        return if @verse_layout == layout
        @verse_layout = layout
        arrange_verses
      end
      
      def verse_layout
        @verse_layout
      end

      feature :verse_space # Space between verses.

      def set_verse_space verse_space
        return if @verse_space == verse_space
        @verse_space = verse_space
        layer&.break_layout
        true
      end
      
      def verse_space
        @verse_space || 0
      end

      feature :verse_size
      
      def set_verse_size verse_size
        return if @verse_size == verse_size
        @verse_size = verse_size
        arrange_verses
      end
      
      def verse_size
        @verse_size
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