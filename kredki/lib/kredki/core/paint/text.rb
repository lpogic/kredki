module Kredki
  class Text < Paint

    # Set content.
    def content! content = @content
      return content! yield @content if block_given?
      return if @content == content
      Pastele.text_set_text @pointer, content.to_s
      @content = content
      update_size
    end

    # See #content!.
    def content= param
      send_ahp :content!, param
    end

    # Get content.
    def content
      @content
    end

    # Get width.
    def w
      @w
    end

    # Set height. It can also affect the width.
    def h! h = @h
      return h! yield @h if block_given?
      return if @h == h
      Pastele.text_set_size @pointer, h
      @h = h
      update_size
    end

    # See #h!.
    def h= param
      send_ahp :h!, param
    end

    # Get height.
    def h
      @h
    end

    # Get width and height.
    def wh
      [@w, @h]
    end

    # Set font.
    def font! font
      return font! yield @font if block_given?
      return if @font == font
      Pastele.text_set_font @pointer, Kredki.font(font).name
      @font = font
      update_size
    end

    # See #font!.
    def font= param
      send_ahp :font!, param
    end

    # Get font.
    def font
      @font
    end

    # Set fill color.
    def fill! *fill
      return send_ahp :fill!, yield(self.fill) if block_given?
      fill = Util.uncover fill
      return if @fill == fill && fill != :rand
      case f = Kredki.fill fill
      when Color
        Pastele.text_set_fill_color @pointer, *f.to_rgb
      when LinearGradient
        Pastele.text_set_fill_linear_gradient @pointer, *f.ffi
      when RadialGradient
        Pastele.text_set_fill_radial_gradient @pointer, *f.ffi
      end
      @fill = fill
      update
    end

    # See #fill!.
    def fill= param
      send_ahp :fill!, param
    end

    # Get fill color.
    def fill
      @fill
    end

    # Set outline features.
    def outline! *a, **ka
      a.map do |it|
        case it
        when Hash
          outline! **it
        when Numeric
          outline_w! it
        else
          send_ahp :outline_fill!, it
        end
      end.any? | send_branch(:outline, ka)
    end
    
    # See #outline!.
    def outline= param
      send_ahp :outline!, param
    end

    # Set outline fill.
    def outline_fill! *outline_fill
      return send_ahp :outline_fill!, yield(self.outline_fill) if block_given?
      outline_fill = Util.uncover outline_fill
      return if @outline_fill == outline_fill && outline_fill != :rand
      update_outline outline_fill, @outline_w
      @outline_fill = outline_fill
      update
    end

    # See #outline_fill!.
    def outline_fill= param
      send_ahp :outline_fill!, param
    end

    # Get outline fill.
    def outline_fill
      @outline_fill
    end

    # Set outline width.
    def outline_w! outline_w = @outline_w
      return outline_w! yield @outline_w if block_given?
      return if @outline_w == outline_w
      update_outline @outline_fill, outline_w
      @outline_w = outline_w
      update
    end

    # See #outline_w!.
    def outline_w= param
      send_ahp :outline_w!, param
    end

    # Get outline width.
    def outline_w
      @outline_w
    end

    # Get +string+ width rendered with +@font+ and +@height+ up to character at +index+. 
    def substring_width index = nil, string = @content
      Pastele.text_get_text_width(@pointer, string.to_s, index || -1)
    end

    # Get index of nearest character for +string+ rendered with +@font+ and +@height+, truncated to +width+.
    def nearest_character_index width, string = @content
      return 0 if width <= 0
      Pastele.text_nearest_character_index @pointer, string.to_s, width
    end

    # Push the feature.
    def << feature
      case feature
      in String
        content! feature
      in Numeric
        h! feature
      else
        super
      end
    end

    # :section: LEVEL 2

    def initialize
      super Pastele.text_new
      ObjectSpace.define_finalizer(self, Text.finalizer(@pointer))

      @content = "TEXT"
      @font = Kredki.font
      @fill = Kredki.color
      @outline_fill = Kredki.color
      @outline_w = 0
      @h = Kredki.text_size
      Pastele.text_set_text @pointer, @content
      Pastele.text_set_font @pointer, @font.name
      Pastele.text_set_size @pointer, @h
      Pastele.text_set_fill_color @pointer, *@fill.to_a(:rgb)
      update_size
    end

    def self.finalizer pointer
      proc{ Pastele.text_delete pointer }
    end

    def pivot_xy
      [@w * 0.5, @h * 0.5]
    end

    def update_size
      @w = substring_width
      update_transform
      update
    end

    def update_outline color, width
      c = Kredki.color color
      Pastele.text_set_outline @pointer, width, *c.to_rgb
    end

  end
end
