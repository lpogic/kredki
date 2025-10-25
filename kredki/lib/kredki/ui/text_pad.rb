module Kredki
  module UI
    class TextPad < Pad
      extend Forwardable
      extend HasParams

      param def content! content = @content
        return content! (yield self.content) if block_given?
        return if @content == content
        @content = content
        @verses&.each{ it.detach! }
        @verses = "#{content}\n".each_line(chomp: true).map do |line|
          @scene.text! line.chomp, color: @area.fill_color
        end
        arrange_verses
        layer&.break_layout
        true
      end

      param def color! *color
        return color! *Util.cover(yield self.color) if block_given?
        return unless @area.fill_color! *color
        @verses.each{ it.color! *color }
        true
      end, def color
        @area.fill_color
      end

      param_prefix :verse

      param def verse_layout! layout = nil
        return verse_layout! (yield self.verse_layout) if block_given?
        return if @verse_layout == layout
        @verse_layout = layout
        arrange_verses
      end

      param def verse_space! verse_space = nil
        return verse_space! (yield self.verse_space) if block_given?
        return if @verse_space == verse_space
        @verse_space = verse_space
        layer&.break_layout
        true
      end, def verse_space
        @verse_space || 0
      end

      def << arg
        case arg
        when String
          content! arg
        else
          super
        end
      end

      param def verse_size! size
        return verse_size! (yield self.verse_size) if block_given?
        return if @verse_size == size
        @verse_size = size
        arrange_verses
      end

      #internal api

      def initialize
        super

        @verses = []
        @verse_size = :auto
      end

      def sketch p0
        super

        wh! :fit
        verse_layout! :bc
        verse_size! 24
        content! "TEXT"
      end

      def verse_metrics h
        case @verse_space
        when Rational
          size = @verse_size == :auto ? h / (1 + (@verses.size - 1) * @verse_space) : @verse_size
          space = size * @verse_space
        when Numeric
          size = @verse_size == :auto ? (h + (@verses.size - 1) * @verse_space) / @verses.size : @verse_size
          space = @verse_space
        when :auto
          if @verses.size > 0
            size = @verse_size == :auto ? h / @verses.size : @verse_size
            space = (h - @verses.size * size) / (@verses.size - 1)
          else
            size = 0
            space = 0
          end
        else
          if @verses.size > 0
            size = @verse_size == :auto ? h / @verses.size : @verse_size
          else
            size = 0
          end
          space = 0
        end
        [size, space]
      end

      def fit_w
        size, _ = verse_metrics get_h
        @verses.map{ size * it.w / it.h }.max
      end

      def fit_h
        size, space = verse_metrics 0
        @myb + @mye + (size + space) * @verses.size - space
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
        when :b, :bb, :bc, :be
          0
        when :e, :eb, :ec, :ee
          w - tw
        when :c, :cb, :cc, :ce
          (w - tw) * 0.5
        else raise_is @verse_layout
        end
      end

      def align_y th, h
        case @verse_layout
        when :bb, :cb, :eb
          0
        when :be, :ce, :ee
          h - th
        when :b, :c, :e, :bc, :cc, :ec
          (h - th) * 0.5
        else raise_is @verse_layout
        end
      end
    end
  end
end