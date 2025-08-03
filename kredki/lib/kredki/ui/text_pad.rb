module Kredki
  module UI
    class TextPad < Pad
      extend Forwardable
      extend HasParams

      param def content! content = @content, &block
        return content! block[self.content] if block_given?
        return if @content == content
        @content = content
        @text&.each{ it.detach! }
        @text = "#{content}\n".each_line(chomp: true).map do |line|
          @scene.text! line.chomp, color: @area.fill_color
        end
        layer&.break_layout
      end

      def color! *color
        super
        @text.each do |line|
          line.color! *color
        end
      end

      param def verse_layout! layout
        return if @verse_layout == layout
        @verse_layout = layout
        set_size @w, @h
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
        layer&.break_layout
        true
      end

      #internal api

      def initialize
        super

        @text = []
        @verse_size = :auto
      end

      def sketch p0
        super

        @area.hide!
        wh! :fit, 24
      end

      def verse_metrics h
        case @linespace
        when Rational
          ls = @linespace.denominator == 1 ? @linespace / 100 : @linespace
          th = @verse_size == :auto ? h / (1 + (@text.size - 1) * ls) : @verse_size
          ls = th * ls
        when Numeric
          th = @verse_size == :auto ? (h + (@text.size - 1) * @linespace) / @text.size : @verse_size
          ls = th + @linespace
        else
          if @text.size > 0
            th = @verse_size == :auto ? h / @text.size : @verse_size
          else
            th = 0
          end
          ls = th
        end
        [th, ls]
      end

      def fit_w
        th, ls = verse_metrics get_h
        @text.map{ th * it.w / it.h }.max
      end

      def fit_h
        @verse_size == :auto ? 0 : @verse_size * @text.size
      end

      def set_size w, h
        super
        if @text.size > 0
          th, ls = verse_metrics h
          y = align_y @text.size * th + (@text.size - 1) * ls, h
          @text.each do |t|
            t.h! th
            x = align_x t.w, w
            t.xy! x, y
            y += ls
          end
        end
      end

      def align_x tw, w
        case @verse_layout
        when :b, :bb, :bc, :be
          (tw - w) / 2
        when :e, :eb, :ec, :ee
          (w - tw) / 2
        else
          0
        end
      end

      def align_y th, h
        case @verse_layout
        when :b, :bb, :cb, :eb
          (th - h) / 2
        when :e, :be, :ce, :ee
          (h - th) / 2
        else
          0
        end
      end

    end
  end
end