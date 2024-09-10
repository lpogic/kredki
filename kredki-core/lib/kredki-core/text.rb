require_relative 'alterable'
require_relative 'paint'
require_relative 'color'
require_relative 'font'

module Kredki
  class Text < Paint
    include Alterable

    Kredki[self, :color] = :white
    Kredki[self, :font] = [:arial, 16]

    def initialize string = "TEXT", x = 0, y = 0, **params, &block
      super Abi.text_new
      ObjectSpace.define_finalizer(self, Text.proc.finalize(@pointer))

      @string = ""
      @font = nil

      alter string:, x:, y:, 
        font: Kredki[self.class, :font], 
        color: Kredki[self.class, :color], 
        **params, &block
    end

    def string! string 
      set_string string.to_s
    end

    alias_method :string=, :string!

    def string 
      @string
    end

    def substring_width index = nil, string = @string
      str = string.to_s
      Abi.text_get_text_width(@pointer, str, index || -1).ceil
    end

    def nearest_character_index width, string = @string
      return 0 if width <= 0
      Abi.text_nearest_character_index @pointer, string.to_s, width
    end

    def w
      substring_width
    end

    def font! *font
      set_font Font[font.extract]
    end

    def font=(font)
      set_font Font[font]
    end

    def font
      @font
    end

    def color! *color
      set_fill_color *Kredki.color(color.extract).to_rgb_array
    end

    def color=(color)
      set_fill_color *Kredki.color(color).to_rgb_array
    end

    alias_method :fill_color!, :color!
    alias_method :fill_color=, :color=

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
      end
    end

    def set_font font
      if @font != font
        # set blank font to workaround size & style change blindness
        Abi.text_set_font @pointer, "AdobeBlank", 1, nil
        Abi.text_set_font @pointer, *font.to_array if font
        @font = font
        update
      end
    end

    def set_fill_color r, g, b
      Abi.text_set_fill_color @pointer, r, g, b
      update
    end
  end
end
