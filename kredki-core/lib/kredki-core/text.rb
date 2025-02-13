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
      string = string.to_s
      string != @string and set_string string
    end

    param def h! h
      @h != h and set_height h
    end, :height

    aliasing def w
      @w
    end, :width

    aliasing def wh
      [@w, @h]
    end, :size

    param def font! font
      font = Kredki.font font
      @font != font and set_font font
    end

    param def color! *color
      color = Kredki.color color.extract
      @color != color and set_fill_color color
    end

    #internal api

    def self.finalize pointer
      Abi.text_delete pointer
    end

    def substring_width index = nil, string = @string
      str = string.to_s
      Abi.text_get_text_width(@pointer, str, index || -1)
    end

    def nearest_character_index width, string = @string
      return 0 if width <= 0
      Abi.text_nearest_character_index @pointer, string.to_s, width
    end

    private

    def set_string string
      Abi.text_set_text @pointer, string
      @string = string
      @w = substring_width
      update
    end

    def set_font font
      @font = font
      update_font
    end

    def set_height h
      @h = h
      update_font
    end

    def update_font
      if @font && @h
        Abi.text_set_font @pointer, @font.name, @h, @style&.encode || ""
        @w = substring_width
        update
      end
    end

    def set_fill_color color
      @color = color
      Abi.text_set_fill_color @pointer, *@color.to_rgb_array
      update
    end
  end
end
