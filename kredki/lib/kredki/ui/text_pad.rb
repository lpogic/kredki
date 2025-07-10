require 'forwardable'

module Kredki
  module UI
    class TextPad < Pad
      extend Forwardable

      param def content! content = @content, &block
        return content! block[self.content] if block_given?
        return if @content == content
        @content = content
        @text.each{ it.detach! }
        @text = "#{content}\n".each_line(chomp: true).map do |line|
          @scene.text! line.chomp, color: @area.color
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
      end

      def << arg
        case arg
        when String
          content! arg
        else
          super
        end
      end

      param def vh! height
        return if @vh == height
        @vh = height
        layer&.break_layout
        true
      end, :verse_height

      #internal api

      def initialize
        super

        wh! :fit, 24
        @text = []
        @vh = :auto
      end

      def sketch p0
        super
        @area.hide!
      end

      def verse_metrics h
        case @linespace
        when Rational
          ls = @linespace.denominator == 1 ? @linespace / 100 : @linespace
          th = @vh == :auto ? h / (1 + (@text.size - 1) * ls) : @vh
          ls = th * ls
        when Numeric
          th = @vh == :auto ? (h + (@text.size - 1) * @linespace) / @text.size : @vh
          ls = th + @linespace
        else
          th = @vh == :auto ? h / @text.size : @vh
          ls = th
        end
        [th, ls]
      end

      def fit_w
        th, ls = verse_metrics get_h
        @text.map{ th * it.w / it.h }.max
      end

      def fit_h
        @vh == :auto ? 0 : @vh * @text.size
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
        when :c, :cc, :cn, :cs
          (w - tw) / 2
        when :e, :ec, :en, :es
          w - tw
        else
          0
        end
      end

      def align_y th, h
        case @verse_layout
        when :cc, :ec, :wc
          (h - th) / 2
        when :cs, :es, :ws
          h - th
        else
          0
        end
      end

    end
  end
end