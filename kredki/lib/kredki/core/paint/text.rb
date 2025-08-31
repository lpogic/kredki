module Kredki
  class Text < Paint

    def initialize
      super Abi.text_new
      ObjectSpace.define_finalizer(self, Text.proc.finalize(@pointer))

      @content = "TEXT"
      @font = Kredki.font
      @color = Kredki.color
      @h = 16
      set_content @content
      set_font @font.name, @h, ""
      set_fill_color *@color.to_rgb_array
      update_size
    end

    def << param
      case param
      in [content, h]
        content! content
        h! h
      in String
        content! param
      in Numeric
        h! param
      else
        super
      end
    end

    param def content! content = nil, &block
      return content! block[@content] if block_given?
      return if @content == content
      set_content content.to_s
      @content = content
      update_size
    end

    def w
      @w
    end

    param def h! s
      return if @h == s
      set_font Kredki.font(@font).name, s, ""
      @h = s
      update_size
    end

    def wh
      [@w, @h]
    end

    param def font! font
      return if @font == font
      set_font Kredki.font(font).name, @h, ""
      @font = font
      update_size
    end

    param def color! *color
      color = color.pick
      return if @color == color && color != :rand
      set_fill_color *Kredki.color(color).to_rgb_array
      @color = color
      update
    end

    #internal api

    def self.finalize pointer
      Abi.text_delete pointer
    end

    def pxy
      [@w * 0.5, @h * 0.5]
    end

    def update_size
      @w = substring_width
      update_transform
      update
    end

    def substring_width index = nil, string = @content
      Abi.text_get_text_width(@pointer, string.to_s, index || -1)
    end

    def nearest_character_index width, string = @content
      return 0 if width <= 0
      Abi.text_nearest_character_index @pointer, string.to_s, width
    end

    def set_content content
      Abi.text_set_text @pointer, content
    end

    def set_font font_name, height, style
      Abi.text_set_font @pointer, font_name, height, style
    end

    def set_fill_color r, g, b
      Abi.text_set_fill_color @pointer, r, g, b
    end
  end
end
