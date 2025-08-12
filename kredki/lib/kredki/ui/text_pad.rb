module Kredki
  module UI
    class TextPad < Pad
      extend Forwardable
      extend HasParams

      param def content! content = @content, &block
        return content! block[self.content] if block_given?
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

      def color! *color
        super
        @verses.each do |v|
          v.color! *color
        end
      end

      param def verse_layout! layout
        return if @verse_layout == layout
        @verse_layout = layout
        arrange_verses
      end

      param def linespace! linespace
        return if @linespace == linespace
        @linespace = linespace
        layer&.break_layout
        true
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

        @area.hide!
        wh! :fit, 24
        verse_layout! :begin_center
        content! "TEXT"
      end

      def verse_metrics h
        case @linespace
        when Rational
          th = @verse_size == :auto ? h / (1 + (@verses.size - 1) * @linespace) : @verse_size
          ls = th * @linespace
        when Numeric
          th = @verse_size == :auto ? (h + (@verses.size - 1) * @linespace) / @verses.size : @verse_size
          ls = th + @linespace
        else
          if @verses.size > 0
            th = @verse_size == :auto ? h / @verses.size : @verse_size
          else
            th = 0
          end
          ls = th
        end
        [th, ls]
      end

      def fit_w
        th, ls = verse_metrics get_h
        @verses.map{ th * it.w / it.h }.max
      end

      def fit_h
        @verse_size == :auto ? 0 : @verse_size * @verses.size
      end

      def set_size w, h
        super and arrange_verses
      end

      def arrange_verses
        if @verses.size > 0
          w, h = swh
          th, ls = verse_metrics h
          tth = (@verses.size - 1) * ls + th
          y = align_y tth, h
          @verses.each do |v|
            v.h! th
            x = align_x v.w, w
            p [x, y, sx, sy]
            v.xy! x, y
            y -= ls
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
        else
          (w - tw) * 0.5
        end
      end

      def align_y th, h
        case @verse_layout
        when :b, :bb, :cb, :eb
          0
        when :e, :be, :ce, :ee
          h - th
        else
          (h - th) * 0.5
        end
      end
    end
  end
end