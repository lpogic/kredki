require_relative 'alterable'
require_relative 'paint'
require_relative 'color'
require_relative 'font'

module Kredki
  class Text < Paint
    include Alterable

    class << self
      attr_accessor :default_color, :default_font
    end

    self.default_color = :white
    self.default_font = [:arial, 16]

    def initialize string = "TEXT", x = 100, y = 100, **params, &block
      super Abi.text_new
      ObjectSpace.define_finalizer(self, self.class.proc.finalize(@pointer))

      @string = ""
      @font = nil

      alter string:, x:, y:, 
        font: self.class.default_font, 
        color: self.class.default_color, 
        **params, &block
    end

    def string! string 
      set_string string.to_s
    end

    alias_method :string=, :string!

    def string 
      @string
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
      set_fill_color *Color[color.extract].to_rgb_array
    end

    def color=(color)
      set_fill_color *Color[color].to_rgb_array
    end

    alias_method :fill_color!, :color!
    alias_method :fill_color=, :color=

    #internal api

    def self.finalize pointer
      Abi.paint_delete pointer
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