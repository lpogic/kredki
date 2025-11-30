module Kredki
  module UI
    class TextPad < Pad

      feature def content! content = @content
        return content! (yield(self.content)) if block_given?
        return if @content == content
        @content = content
        @verses&.each{ it.detach! }
        @verses = "#{content}\n".each_line(chomp: true).map do |line|
          @scene.text! line.chomp, fill: @area.fill
        end
        arrange_verses
        layer&.break_layout
        true
      end

      feature def fill! *fill
        return fill! *Util.cover(yield(self.fill)) if block_given?
        return unless @area.fill! *fill
        @verses.each{ it.fill! *fill }
        true
      end, def fill
        @area.fill
      end

      feature def verse! *a, **na
        amap = a.map do
          case it
          when Hash
            verse! **it
          when Numeric, :auto
            verse_size! it
          else
            verse_layout! it
          end
        end
        namap = na.map do
          send "verse_#{_1}!", *Util.cover(_2)
        end
        amap.any? || namap.any?
      end, def verse
        [verse_size, verse_layout]
      end

      feature def verse_layout! layout = nil
        return verse_layout! (yield(self.verse_layout)) if block_given?
        return if @verse_layout == layout
        @verse_layout = layout
        arrange_verses
      end

      feature def verse_space! verse_space = nil
        return verse_space! (yield(self.verse_space)) if block_given?
        return if @verse_space == verse_space
        @verse_space = verse_space
        layer&.break_layout
        true
      end, def verse_space
        @verse_space || 0
      end

      feature def verse_size! size
        return verse_size! (yield(self.verse_size)) if block_given?
        return if @verse_size == size
        @verse_size = size
        arrange_verses
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

      def initialize
        super

        @verses = []
        @verse_size = :auto
      end

      def sketch
        super

        wh! :fit
        verse_layout! :ybc
        verse_size! 24
        content! "TEXT"
      end

      def verse_metrics h
        case @verse_size
        when :auto
          size = 0
          case @verse_space
          when Rational
            size = h / (1 + (@verses.size - 1) * @verse_space) if @verses.size > 0
            space = size * @verse_space
          when Numeric
            size = (h + (@verses.size - 1) * @verse_space) / @verses.size if @verses.size > 0
            space = @verse_space
          when :auto
            if @verses.size > 0
              size = h / @verses.size
              space = (h - @verses.size * size) / (@verses.size - 1)
            else
              space = 0
            end
          else
            size = h / @verses.size if @verses.size > 0
            space = 0
          end
        when Rational
          size = @verses.size > 0 ? @verse_size * h : 0
          case @verse_space
          when Rational
            space = size * @verse_space
          when Numeric
            space = @verse_space
          when :auto
            if @verses.size > 0
              space = (h - @verses.size * size) / (@verses.size - 1)
            else
              space = 0
            end
          else
            space = 0
          end
        else
          size = @verses.size > 0 ? @verse_size : 0
          case @verse_space
          when Rational
            space = size * @verse_space
          when Numeric
            space = @verse_space
          when :auto
            if @verses.size > 0
              space = (h - @verses.size * size) / (@verses.size - 1)
            else
              space = 0
            end
          else
            space = 0
          end
        end

        [size, space]
      end

      def fit_w
        size, _ = verse_metrics get_h
        @verses.map{ size * it.w / it.h }.max
      end

      def fit_h
        size, space = verse_metrics 0
        @myt + @myh + (size + space) * @verses.size - space
      end

      def set_size w, h
        super and arrange_verses
      end

      def arrange_verses
        if @verses.size > 0
          w, h = swh
          size, space = verse_metrics h
          tsize = (size + space) * @verses.size - space
          y = align_y tsize, h
          @verses.each do |v|
            v.h! size
            x = align_x v.w, w
            v.xy! x, y
            y += size + space
          end
        end
        true
      end

      def align_x tw, w
        case @verse_layout
        when :ybb, :ybc, :ybe
          0
        when :yeb, :yec, :yee
          w - tw
        when :ycb, :ycc, :yce
          (w - tw) * 0.5
        else raise_is @verse_layout
        end
      end

      def align_y th, h
        case @verse_layout
        when :ybb, :ycb, :yeb
          0
        when :ybe, :yce, :yee
          h - th
        when :ybc, :ycc, :yec
          (h - th) * 0.5
        else raise_is @verse_layout
        end
      end
    end
  end
end