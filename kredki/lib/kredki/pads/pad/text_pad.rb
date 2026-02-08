module Kredki
  module Pads
    # Pad with text area.
    class TextPad < Pad

      # Set content.
      def content! content = @content
        return send_ahp :content!, yield(self.content) if block_given?
        return if @content == content
        @content = content
        font = @verses.first&.font || Kredki.font
        @verses&.each{|it| it.detach }
        @verses = "#{content}\n".each_line(chomp: true).map do |line|
          @scene.text! line.chomp, fill: @area.fill, font: font
        end
        arrange_verses
        layer&.break_layout
        true
      end

      # See #content!.
      def content= param
        send_ahp :content!, param
      end

      # Get content.
      def content
        @content
      end

      # Set fill.
      def fill! *fill
        return send_ahp :fill!, yield(self.fill) if block_given?
        return unless @area.fill! *fill
        @verses.each{|it| it.fill! *fill }
        true
      end
      
      # See #fill!.
      def fill= param
        send_ahp :fill!, param
      end

      # Get fill.
      def fill
        @area.fill
      end

      # Set outline features.
      def outline! *a, **na
        a.map do |it|
          case it
          when Hash
            outline! **it
          when Numeric
            outline_w! it
          else
            send_ahp :outline_fill!, it
          end
        end.any? | send_branch(:outline, na)
      end
      
      # See #outline!.
      def outline= param
        send_ahp :outline!, param
      end

      # Set outline fill.
      def outline_fill! *outline_fill
        return send_ahp :outline_fill!, yield(self.outline_fill) if block_given?
        return unless @area.outline_fill! *outline_fill
        @verses.each{|it| it.outline_fill! *outline_fill }
        true
      end

      # See #outline_fill!.
      def outline_fill= param
        send_ahp :outline_fill!, param
      end

      # Get outline fill.
      def outline_fill
        @area.fill
      end

      # Set outline width.
      def outline_w! outline_w = @outline_w
        return send_ahp :outline_w!, yield(self.outline_w) if block_given?
        return unless @area.outline_w! *outline_w
        @verses.each{|it| it.outline_w! *outline_w }
        true
      end

      # See #outline_w!.
      def outline_w= param
        send_ahp :outline_w!, param
      end

      # Get outline width.
      def outline_w
        @area.fill
      end

      # Set verse features.
      def verse! *a, **na
        a.map do |it|
          case it
          when Hash
            verse! **it
          when Numeric, :auto
            verse_size! it
          else
            verse_layout! it
          end
        end.any? | send_branch(:verse, na)
      end

      # See #verse!.
      def verse= param
        send_ahp :verse!, param
      end

      # Set verse layout.
      def verse_layout! layout = nil
        return send_ahp :verse_layout!, yield(self.verse_layout) if block_given?
        return if @verse_layout == layout
        @verse_layout = layout
        arrange_verses
      end

      # See #verse_layout!.
      def verse_layout= param
        send_ahp :verse_layout!, param
      end

      # Get verse layout.
      def verse_layout
        @verse_layout
      end

      # Set space between verses.
      def verse_space! verse_space = @verse_space
        return send_ahp :verse_space!, yield(self.verse_space) if block_given?
        return if @verse_space == verse_space
        @verse_space = verse_space
        layer&.break_layout
        true
      end
      
      # See #verse_space!.
      def verse_space= param
        send_ahp :verse_space!, param
      end
      
      # Get spece between verses.
      def verse_space
        @verse_space || 0
      end

      # Set verse size.
      def verse_size! verse_size = @verse_size
        return send_ahp :verse_size!, yield(self.verse_size) if block_given?
        return if @verse_size == verse_size
        @verse_size = verse_size
        arrange_verses
      end

      # See #verse_size!.
      def verse_size= param
        send_ahp :verse_size!, param
      end

      # Get verse size.
      def verse_size
        @verse_size
      end

      # Push the feature.
      def << feature
        case feature
        when String
          content! feature
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

        wh! Fit
        verse_layout! :ysc
        verse_size! 20
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
        @verses.map{|it| size * it.w / it.h }.max
      end

      def fit_h
        size, space = verse_metrics 0
        @mys + @mye + (size + space) * @verses.size - space
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
        when :yss, :ysc, :yse
          0
        when :yes, :yec, :yee
          w - tw
        when :ycs, :ycc, :yce
          (w - tw) * 0.5
        else raise_is @verse_layout
        end
      end

      def align_y th, h
        case @verse_layout
        when :yss, :ycs, :yes
          0
        when :yse, :yce, :yee
          h - th
        when :ysc, :ycc, :yec
          (h - th) * 0.5
        else raise_is @verse_layout
        end
      end
    end
  end
end