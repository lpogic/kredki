module Kredki
  # Base class for all graphical objects.
  class Paint

    # Set position along the X axis.
    def set_x x = @x
      return set_x yield @x if block_given?
      return if @x == x
      @x = x
      update_transform
      update
    end
    
    # See #set_x.
    def x= param
      send_bundle :set_x, param
    end

    # Get position along the X axis.
    def x
      @x
    end

    # Set position along the Y axis.
    def set_y y = @y
      return set_y yield @y if block_given?
      return if @y == y
      @y = y
      update_transform
      update
    end

    # See #set_y.
    def y= param
      send_bundle :set_y, param
    end

    # Get position along the X axis.
    def y
      @y
    end

    # Set position along X and Y axes.
    def set_xy x = @x, y = x
      return send_bundle :set_xy, yield(self.xy) if block_given?
      return if @x == x && @y == y
      @x = x
      @y = y
      update_transform
      update
    end
    
    # See #set_xy.
    def xy= param
      send_bundle :set_xy, param
    end

    # Get position along X and Y axes.
    def xy
      [@x, @y]
    end
 
    # Set turn around the pivot point.
    def set_turn turn = @turn
      return set_turn yield @turn if block_given?
      return if @turn == turn
      @turn = turn
      update_transform
      update
    end

    # See #set_turn.
    def turn= param
      send_bundle :set_turn, param
    end

    # Get turn around the pivot point.
    def turn
      @turn
    end

    # Set zoom in the X axis.
    def set_zoom_x zoom_x = @zoom_x
      return set_zoom_x yield @zoom_x if block_given?
      return if @zoom_x == zoom_x
      @zoom_x = zoom_x
      update_transform
      update
    end

    # See #set_zoom_x.
    def zoom_x= param
      send_bundle :set_zoom_x, param
    end

    # Get zoom in the X axis.
    def zoom_x
      @zoom_x
    end

    # Set zoom in the Y axis.
    def set_zoom_y zoom_y = @zoom_y
      return set_zoom_y yield @zoom_y if block_given?
      return if @zoom_y == zoom_y
      @zoom_y = zoom_y
      update_transform
      update
    end

    # See #set_zoom_y.
    def zoom_y= param
      send_bundle :set_zoom_y, param
    end

    # Get zoom in the Y axis.
    def zoom_y
      @zoom_y
    end

    # Set zoom in X and Y axes.
    def set_zoom zoom_x = @zoom_x, zoom_y = zoom_x, **ka
      return send_bundle :set_zoom, yield(self.zoom) if block_given?
      unless @zoom_x == zoom_x && @zoom_y == zoom_y
        @zoom_x = zoom_x
        @zoom_y = zoom_y
        update_transform
        update
      end | send_branch(__method__, ka)
    end

    # See #set_zoom.
    def zoom= param
      send_bundle :set_zoom, param
    end

    # Get zoom in X and Y axes.
    def zoom
      [@zoom_x, @zoom_y]
    end

    # Set opacity degree.
    def set_opacity opacity = @opacity
      return set_opacity yield @opacity if block_given?
      return if @opacity == opacity
      Pastele.paint_set_opacity @pointer, opacity.to_i
      @opacity = opacity
      update
    end

    # See #set_opacity.
    def opacity= param
      send_bundle :set_opacity, param
    end

    # Get opacity degree.
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

    # Set color blending method.
    def set_blend blend = @blend
      return set_blend yield @blend if block_given?
      return if @blend == blend
      Pastele.paint_set_blend_method @pointer, BlendMethod.send(blend || :normal)
      @blend = blend
      update
    end

    # See #set_blend.
    def blend= param
      send_bundle :set_blend, param
    end

    # Get color blending method.
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

    # Set color masking method with +target+.
    def set_mask mask = @mask, target = nil
      return send_bundle :set_mask, yield(@mask, @mask_target) if block_given?
      return if @mask == mask && @mask_target == target
      @mask_target&.unset_masking
      target&.update_masking self
      Pastele.paint_set_mask @pointer, target&.pointer, MaskMethod.send(mask || :none)
      @mask = mask
      @mask_target = target
      update
    end

    # See #set_mask.
    def mask= param
      send_bundle :set_mask, param
    end

    # Get color masking method.
    def mask
      @mask
    end

    # Set whether Paint is scenic.
    #
    # All lower level Scenes must be scenic for the Paint to be displayed.
    def set_scenic value = true
      return if (c = scenic) == (value = block_given? ? yield(c) : value == Not ? !c : value)
      update_scenic value
      true
    end

    # See #set_scenic.
    def scenic= value
      set_scenic value
    end
    
    # Get whether Paint is scenic.
    def scenic
      @scene&.paint_scenic self
    end

    # Get whether Paint is displayed.
    def displayed
      @scene&.paint_displayed self
    end

    # Set the Kredki::Shape to use as the Paint clipping path.
    def set_clip clip = @clip
      return yield @clip if block_given?
      clip = nil unless clip
      return if @clip == clip
      @clip&.unset_masking
      clip&.update_masking self
      Pastele.paint_set_clip @pointer, clip&.pointer
      @clip = clip
      update
    end

    # See #set_clip.
    def clip= param
      send_bundle :set_clip, param
    end

    # Get the Kredki::Shape used as the Paint clipping path.
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
    def attach scene, hidden = false, at = nil
      @scene&.delete_paint self
      scene.put_paint self, scenic, at
      @scene = scene
    end

    # Get window.
    def window
      @scene&.window
    end

    # Set a feature recognized by its class.
    def << feature
      case feature
      when Hash
        set **feature
      when Array
        set *feature
      when Proc
        set &feature
      else
        raise "Unsupported << (#{feature} : #{feature.class})"
      end
      self
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

    def update_scenic scenic
      scenic ? @scene&.show_paint(self) : @scene&.hide_paint(self)
    end

    def pivot
      [0, 0]
    end

    def update_transform
      Pastele.paint_set_transform @pointer, *pivot, @x, @y, 2 * Math::PI * @turn, @zoom_x, @zoom_y
    end
  end#Paint
end#Kredki
