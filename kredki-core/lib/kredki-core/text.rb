require_relative 'paint'
require_relative 'color'
require_relative 'font'

module Kredki
  class Text < Paint
    include Alterable

    def initialize
      super Abi.text_new
      ObjectSpace.define_finalizer(self, Text.proc.finalize(@pointer))

      @string = "TEXT"
      @font = Kredki.font
      @color = Kredki.color
      @h = 16
      set_string @string
      set_font @font.name, @h, ""
      set_fill_color *@color.to_rgb_array
      @w = substring_width
      update
    end

    def <<(arg)
      case arg
      in [string, height]
        string! string
        height! height
      in String
        string! arg
      in Numeric
        height! arg
      else
        raise ArgumentError.new "#{arg} #{arg.class}"
      end
    end

    param def string! string
      return if @string == string
      set_string string.to_s
      @string = string
      @w = substring_width
      update
    end

    param def h! h
      return if @h == h
      set_font Kredki.font(@font).name, h, ""
      @h = h
      @w = substring_width
      update
    end, :height

    aliasing def w
      @w
    end, :width

    aliasing def wh
      [@w, @h]
    end, :size

    param def font! font
      return if @font == font
      set_font Kredki.font(font).name, @h, ""
      @font = font
      @w = substring_width
      update
    end

    param def color! *color
      color = color.size > 1 ? color : color.first
      return if @color == color
      set_fill_color *Kredki.color(color).to_rgb_array
      @color = color
      update
    end

    #internal api

    def self.finalize pointer
      Abi.text_delete pointer
    end

    def substring_width index = nil, string = @string
      Abi.text_get_text_width(@pointer, string.to_s, index || -1)
    end

    def nearest_character_index width, string = @string
      return 0 if width <= 0
      Abi.text_nearest_character_index @pointer, string.to_s, width
    end

    def set_string string
      Abi.text_set_text @pointer, string
    end

    def set_font font_name, height, style
      Abi.text_set_font @pointer, font_name, height, style
    end

    def set_fill_color r, g, b
      Abi.text_set_fill_color @pointer, r, g, b
    end
  end
end
