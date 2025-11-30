module Kredki
  class Text < Paint

    # Set content.
    def content! content = @content
      return content! yield @content if block_given?
      return if @content == content
      set_content content.to_s
      @content = content
      update_size
    end

    # See #content!.
    def content= param
      Array === param ? (content! *param) : (content! param)
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
      set_size h
      @h = h
      update_size
    end

    # See #h!.
    def h= param
      Array === param ? (h! *param) : (h! param)
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
      set_font Kredki.font(font).name
      @font = font
      update_size
    end

    # See #font!.
    def font= param
      Array === param ? (font! *param) : (font! param)
    end

    # Get font.
    def font
      @font
    end

    # Set fill color.
    def fill! *fill
      return fill! *Util.cover(yield(self.fill)) if block_given?
      fill = Util.uncover fill
      return if @fill == fill && fill != :rand
      set_fill *Kredki.color(fill).to_a(:rgb)
      @fill = fill
      update
    end

    # See #fill!.
    def fill= param
      Array === param ? (fill! *param) : (fill! param)
    end

    # Get fill color.
    def fill
      @fill
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
      in [content, h]
        content! content
        h! h
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
      ObjectSpace.define_finalizer(self, Text.proc.finalize(@pointer))

      @content = "TEXT"
      @font = Kredki.font
      @fill = Kredki.color
      @h = 16
      set_content @content
      set_font @font.name
      set_size @h
      set_fill *@fill.to_a(:rgb)
      update_size
    end

    def self.finalize pointer
      Pastele.text_delete pointer
    end

    def pxy
      [@w * 0.5, @h * 0.5]
    end

    def update_size
      @w = substring_width
      update_transform
      update
    end

    def set_content content
      Pastele.text_set_text @pointer, content
    end

    def set_font font_name
      Pastele.text_set_font @pointer, font_name
    end

    def set_size size
      Pastele.text_set_size @pointer, size
    end

    def set_fill r, g, b
      Pastele.text_set_fill_color @pointer, r, g, b
    end
  end
end
