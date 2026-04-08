module Kredki
  class Text < Paint

    # Set content.
    def set_content content = @content
      return set_content yield @content if block_given?
      return if @content == content
      Pastele.text_set_text @pointer, content.to_s
      @content = content
      update_size
    end

    # See #set_content.
    def content= param
      send_bundle :set_content, param
    end

    # Get content.
    def content
      @content
    end

    # Get size in X axis.
    def size_x
      @size_x
    end

    # Set size in X axis. It can also affect the size in Y axis.
    def set_size_y size_y = @size_y
      return set_size_y yield @size_y if block_given?
      return if @size_y == size_y
      Pastele.text_set_size @pointer, size_y
      @size_y = size_y
      update_size
    end

    # See #set_size_y.
    def size_y= param
      send_bundle :set_size_y, param
    end

    # Get size in Y axis.
    def size_y
      @size_y
    end

    # Get size.
    def size
      [@size_x, @size_y]
    end

    # Set font.
    def set_font font
      return set_font yield @font if block_given?
      return if @font == font
      Pastele.text_set_font @pointer, Kredki.font(font).name
      @font = font
      update_size
    end

    # See #set_font.
    def font= param
      send_bundle :set_font, param
    end

    # Get font.
    def font
      @font
    end

    # Set fill color.
    def set_fill *fill
      return send_bundle :set_fill, yield(self.fill) if block_given?
      fill = Util.uncover fill
      return if @fill == fill && fill != :random
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

    # See #set_fill.
    def fill= param
      send_bundle :set_fill, param
    end

    # Get fill color.
    def fill
      @fill
    end

    # Set stroke features.
    def set_stroke *a, **ka
      a.map do |it|
        case it
        when Hash
          set_stroke **it
        when Numeric
          set_stroke_width it
        else
          send_bundle :set_stroke_fill, it
        end
      end.any? | send_branch(__method__, ka)
    end
    
    # See #set_stroke.
    def stroke= param
      send_bundle :set_stroke, param
    end

    # Set stroke fill.
    def set_stroke_fill *stroke_fill
      return send_bundle :set_stroke_fill, yield(self.stroke_fill) if block_given?
      stroke_fill = Util.uncover stroke_fill
      return if @stroke_fill == stroke_fill && stroke_fill != :random
      update_stroke stroke_fill, @stroke_width
      @stroke_fill = stroke_fill
      update
    end

    # See #set_stroke_fill.
    def stroke_fill= param
      send_bundle :set_stroke_fill, param
    end

    # Get stroke fill.
    def stroke_fill
      @stroke_fill
    end

    # Set stroke width.
    def set_stroke_width stroke_width = @stroke_width
      return set_stroke_width yield @stroke_width if block_given?
      return if @stroke_width == stroke_width
      update_stroke @stroke_fill, stroke_width
      @stroke_width = stroke_width
      update
    end

    # See #set_stroke_width.
    def stroke_width= param
      send_bundle :set_stroke_width, param
    end

    # Get stroke width.
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

    # Set a feature recognized by its class.
    def << feature
      case feature
      in String
        set_content feature
      in Numeric
        set_size_y feature
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
