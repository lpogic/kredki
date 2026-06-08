module Kredki
  # Base class for all graphical objects.
  class Paint

    def mixed_set feature
      case feature
      when Hash
        set **feature
      when Array
        set *feature
      when Proc
        set &feature
      else
        raise "Unsupported auto set (#{feature} : #{feature.class})"
      end
      self
    end

    feature :x # Position along the X axis.

    def set_x x
      return if @x == x
      @x = x
      update_transform
      update
    end
    
    def x
      @x
    end

    feature :y # Position along the Y axis.

    def set_y y
      return if @y == y
      @y = y
      update_transform
      update
    end

    def y
      @y
    end

    feature :xy # Position along X and Y axes.

    def set_xy x, y = x
      return if @x == x && @y == y
      @x = x
      @y = y
      update_transform
      update
    end
    
    def xy
      [@x, @y]
    end
 
    feature :turn # Turn around the pivot point.

    def set_turn turn
      return if @turn == turn
      @turn = turn
      update_transform
      update
    end
    
    def turn
      @turn
    end

    feature :zoom_x # Zoom in the X axis.

    def set_zoom_x zoom_x
      return if @zoom_x == zoom_x
      @zoom_x = zoom_x
      update_transform
      update
    end
    
    def zoom_x
      @zoom_x
    end

    feature :zoom_y # Zoom in the Y axis.

    def set_zoom_y zoom_y
      return if @zoom_y == zoom_y
      @zoom_y = zoom_y
      update_transform
      update
    end
    
    def zoom_y
      @zoom_y
    end

    feature :zoom # Zoom in X and Y axes.

    def set_zoom zoom_x = @zoom_x, zoom_y = zoom_x, **ka
      unless @zoom_x == zoom_x && @zoom_y == zoom_y
        @zoom_x = zoom_x
        @zoom_y = zoom_y
        update_transform
        update
      end | nest_set(__method__, ka)
    end
    
    def zoom
      [@zoom_x, @zoom_y]
    end

    feature :opacity
    
    def set_opacity opacity
      return if @opacity == opacity
      Pastele.paint_set_opacity @pointer, opacity.to_i
      @opacity = opacity
      update
    end
    
    def opacity
      @opacity
    end

    # Available blending methods.
    class BlendMethod
      class << self
        # Blending disabled (default).
        def normal = 0
        def add = 1
        def screen = 2
        def multiply = 3
        def overlay = 4
        def difference = 5
        def exclusion = 6
        def srcover = 7
        def darken = 9
        def lighten = 10
        def color_dodge = 11
        def color_burn = 12
        def hard_light = 13
        def soft_light = 14
      end
    end

    feature :blend # Color blending method.

    def set_blend blend
      return if @blend == blend
      Pastele.paint_set_blend_method @pointer, BlendMethod.send(blend || :normal)
      @blend = blend
      update
    end

    def blend
      @blend
    end

    # Available masking methods.
    class MaskMethod
      class << self
        # Masking disabled (default).
        def none = 0
        def alpha = 1
        def inv_alpha = 2
        def luma = 3
        def inv_luma = 4
        def add = 5
        def substract = 6
        def intersect = 7
        def difference = 8
        def lighten = 9
        def darken = 10
      end
    end

    feature :mask # Color masking method with +target+.

    def set_mask mask, target = nil
      return if @mask == mask && @mask_target == target
      @mask_target&.unset_masking
      target&.update_masking self
      Pastele.paint_set_mask @pointer, target&.pointer, MaskMethod.send(mask || :none)
      @mask = mask
      @mask_target = target
      update
    end

    def mask
      @mask
    end

    feature :scenic # Whether Paint is scenic. All lower level Scenes must be scenic for the Paint to be displayed.

    def set_scenic value = true
      return if (c = scenic) == (value = value == Not ? !c : value)
      Pastele.paint_set_visible @pointer, value ? 1 : 0
      true
    end
    
    def scenic
      Pastele.paint_get_visible(@pointer) != 0
    end

    # Get whether Paint is displayed.
    def displayed
      Pastele.paint_get_displayed(@pointer) != 0
    end

    feature :clip # The Kredki::Shape to use as the Paint clipping path.

    def set_clip clip
      clip = nil unless clip
      return if @clip == clip
      @clip&.unset_masking
      clip&.update_masking self
      Pastele.paint_set_clip @pointer, clip&.pointer
      @clip = clip
      update
    end

    def clip
      @clip
    end

    # Get the extreme coordinates occupied by the Paint.
    def bounds
      bounds = Pastele::Bounds.malloc(Fiddle::RUBY_FREE)
      Pastele.paint_get_bounds @pointer, bounds
      bounds
    end

    # Detach the Paint from the containing Kredki::Scene.
    def detach
      @scene&.delete_paint self
      @scene = nil
    end

    # Attach the Paint to the Kredki::Scene.
    def attach scene, at = nil
      @scene&.delete_paint self
      scene.put_paint self, at
      @scene = scene
    end

    # Get window.
    def window
      @scene&.window
    end
    
    # Get features.
    def to_hash
      {
        x: @x,
        y: @y,
        turn: @turn,
        zoom_x: @zoom_x,
        zoom_y: @zoom_y,
        opacity: @opacity,
        blend: @blend,
      }
    end

    # :section: LEVEL 2

    def initialize pointer
      @pointer = pointer
      @scene = nil
      @x = 0
      @y = 0
      @turn = 0
      @zoom_x = 1
      @zoom_y = 1
      @opacity = 255
      @blend = nil
    end

    attr :pointer
    attr_accessor :scene

    def inspect
      "#{self.class}:#{object_id}"
    end

    def update_masking scene
      @scene&.delete_paint self unless @is_mask
      @scene = scene
      @is_mask = true
    end

    def unset_masking
      @scene = nil
      @is_mask = false
    end

    def update
      if @is_mask
        @scene.update
      else
        @scene&.update_paint self
        true
      end
    end

    def pivot
      [0, 0]
    end

    def update_transform
      Pastele.paint_set_transform @pointer, *pivot, @x, @y, 2 * Math::PI * @turn, @zoom_x, @zoom_y
    end
  end#Paint
end#Kredki
