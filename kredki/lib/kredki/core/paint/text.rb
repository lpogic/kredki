module Kredki
  class Text < Paint

    def mixed_set feature
      case feature
      in String
        set_content feature
      in Numeric
        set_size_y feature
      else
        super
      end
    end

    feature :content

    def set_content content
      return if @content == content
      Pastele.text_set_text @pointer, content.to_s
      @content = content
      update_size
    end

    def content
      @content
    end

    # Get size in X axis.
    def size_x
      @size_x
    end

    feature :size_y # Size in X axis.
    
    def set_size_y size_y
      return if @size_y == size_y
      Pastele.text_set_size @pointer, size_y
      @size_y = size_y
      update_size
    end
    
    def size_y
      @size_y
    end

    # Get size.
    def size
      [@size_x, @size_y]
    end

    feature :font
    
    def set_font font
      return if @font == font
      Pastele.text_set_font @pointer, Kredki.font(font).name
      @font = font
      update_size
    end
    
    def font
      @font
    end

    feature :fill
    
    def set_fill *fill
      fill = Util.uncover fill
      return if @fill == fill && fill != :random
      norm_fill = Kredki.fill fill
      case norm_fill
      when Color
        Pastele.text_set_fill_color @pointer, *norm_fill.to_rgb
      when LinearGradient
        Pastele.text_set_fill_linear_gradient @pointer, *norm_fill.ffi
      when RadialGradient
        Pastele.text_set_fill_radial_gradient @pointer, *norm_fill.ffi
      end
      @fill = fill
      update
    end
    
    def fill
      @fill
    end

    feature :stroke
    
    def set_stroke *a, **ka
      a.count do |it|
        case it
        when Numeric
          set_stroke_width it
        else
          mixed_set_stroke_fill it
        end
      end.zero?.not | nest_set(__method__, ka)
    end
    
    feature :stroke_fill
    
    def set_stroke_fill *stroke_fill
      stroke_fill = Util.uncover stroke_fill
      return if @stroke_fill == stroke_fill && stroke_fill != :random
      update_stroke stroke_fill, @stroke_width
      @stroke_fill = stroke_fill
      update
    end
    
    def stroke_fill
      @stroke_fill
    end

    feature :stroke_width

    def set_stroke_width stroke_width
      return if @stroke_width == stroke_width
      update_stroke @stroke_fill, stroke_width
      @stroke_width = stroke_width
      update
    end
    
    def stroke_width
      @stroke_width
    end

    # Get +string+ width rendered with +@font+ and +@size_y+ up to character at +index+.
    # If +index+ is +null+ or -1, +string+ width is returned.
    # If +index+ is equal to string length, +string+ width is returned plus last character rsb.
    def substring_width index = nil, string = @content
      Pastele.text_get_text_width(@pointer, string.to_s, index || -1).ceil
    end

    # Get index of nearest character for +string+ rendered with +@font+ and +@size_y+, truncated to +size_max+.
    def nearest_character_index size_max, string = @content
      return 0 if size_max <= 0
      Pastele.text_nearest_character_index @pointer, string.to_s, size_max
    end

    # :section: LEVEL 2

    def initialize
      super Pastele.text_new
      ObjectSpace.define_finalizer(self, Text.finalizer(@pointer))

      @content = "TEXT"
      @font = Kredki.font
      @fill = Kredki.color
      @stroke_fill = Kredki.color
      @stroke_width = 0
      @size_y = Kredki.text_size
      
      Pastele.text_set_text @pointer, @content
      Pastele.text_set_font @pointer, @font.name
      Pastele.text_set_size @pointer, @size_y
      Pastele.text_set_fill_color @pointer, *@fill.to_a(:rgb)
      update_size
    end

    def self.finalizer pointer
      proc{ Pastele.text_delete pointer }
    end

    def pivot
      [@size_x * 0.5, @size_y * 0.5]
    end

    def update_size
      @size_x = substring_width
      update_transform
      update
    end

    def update_stroke color, width
      c = Kredki.color color
      Pastele.text_set_outline @pointer, width, *c.to_rgb
    end

  end
end
