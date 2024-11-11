require_relative 'paint'
require_relative 'color'
require_relative 'font'

module Kredki
  class Text < Paint
    include Alterable

    def initialize
      super Abi.text_new
      ObjectSpace.define_finalizer(self, Text.proc.finalize(@pointer))

      string! "TEXT"
      font! :arial
      height! 16
      color! :white
    end

    aliasing def s! string 
      set_string string.to_s
    end, :s=, :string!, :string=

    aliasing def s 
      @string
    end, :string

    def substring_width index = nil, string = @string
      str = string.to_s
      Abi.text_get_text_width(@pointer, str, index || -1).ceil
    end

    def nearest_character_index width, string = @string
      return 0 if width <= 0
      Abi.text_nearest_character_index @pointer, string.to_s, width
    end

    aliasing def h! h
      set_height h
    end, :h=, :height!, :height=

    aliasing def h
      @h
    end, :height

    aliasing def w
      @w
    end, :width

    aliasing def wh
      [@w, @h]
    end, :size

    aliasing def font! font
      set_font Kredki.font(font)
    end, :font=

    def font
      @font
    end

    def color! *color
      self.color = color.extract
    end

    def color= color
      set_fill_color Kredki.color(color)
    end

    def color
      @color
    end

    #internal api

    def self.finalize pointer
      Abi.text_delete pointer
    end

    private

    def set_string string
      if string != @string
        Abi.text_set_text @pointer, string
        @string = string
        update
        @w = substring_width
      end
    end

    def set_font font
      if @font != font
        @font = font
        update_font
      end
    end

    def set_height h
      if @h != h
        @h = h
        update_font
      end
    end

    def update_font
      if @font && @h
        Abi.text_set_font @pointer, @font.name, @h, @style&.encode || ""
        update
        @w = substring_width
      end
    end

    def set_fill_color color
      if @color != color
        @color = color
        Abi.text_set_fill_color @pointer, *@color.to_rgb_array if @color
        update
      end
    end
  end
end
