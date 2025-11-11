# @public
module Kredki
  # @public
  class Paint
    extend HasParams

    # @group Params

    # @public
    # Position along the X axis.
    param def x! x = @x
      return x! yield @x if block_given?
      return if @x == x
      @x = x
      update_transform
      update
    end

    # @public
    # Position along the Y axis.
    param def y! y = @y
      return y! yield @y if block_given?
      return if @y == y
      @y = y
      update_transform
      update
    end

    # @public
    # Position along X and Y axes.
    param def xy! x = nil, y = nil
      return xy! *Util.cover(yield self.xy) if block_given?
      if x
        y ||= x
      else
        x ||= @x
        y ||= @y
      end
      return if @x == x && @y == y
      @x = x
      @y = y
      update_transform
      update
    end, def xy
      [@x, @y]
    end

    # @public
    # The angle of rotation around the pivot point.
    param def rot! rot = @rot
      return rot! yield @rot if block_given?
      return if @rot == rot
      @rot = rot
      update_transform
      update
    end

    # @public
    # The factor of magnification along the X axis.
    param def magx! magx = @magx
      return magx! yield @magx if block_given?
      return if @magx == magx
      @magx = magx
      update_transform
      update
    end

    # @public
    # The factor of magnification along the Y axis.
    param def magy! magy = @magy
      return magy! yield @magy if block_given?
      return if @magy == magy
      @magy = magy
      update_transform
      update
    end

    # @public
    # The factor of magnification along X and Y axes.
    # @param magx [Numeric] The factor of magnification along the X axis.
    # @param magy [Numeric, nil] The factor of magnification along the Y axis. Default is _magx_.
    param def mag! magx = nil, magy = nil
      return mag! *Util.cover(yield self.mag) if block_given?
      if magx
        magy ||= magx
      else
        magx ||= @magx
        magy ||= @magy
      end
      return if @magx == magx && @magy == magy
      @magx = magx
      @magy = magy
      update_transform
      update
    end, def mag
      [@magx, @magy]
    end

    # @public
    # The degree of opacity.
    param def opacity! opacity = @opacity
      return opacity! yield @opacity if block_given?
      return if @opacity == opacity
      set_opacity opacity.to_i
      @opacity = opacity
      update
    end

    # @public
    class BlendMethod
      enum :normal, :add, :screen, :multiply, :overlay, :difference,
        :exclusion, :srcover, :darken, :lighten, :colordodge, :colorburn,
        :hardlight, :softlight
    end

    # @public
    # The blending method of colors.
    param def blend! blend = @blend
      return blend! yield @blend if block_given?
      return if @blend == blend
      set_blend BlendMethod[blend || :normal].to_i
      @blend = blend
      update
    end

    # @public
    class MaskMethod
      enum :none, :alpha, :inv_alpha, :luma, :inv_luma
      # :add, :substract, :intersect, :difference, :lighten, :darken
    end

    # @public
    # The masking method of colors.
    param def mask! mask = @mask, target = nil
      return mask! *Util.cover(yield @mask, @mask_target) if block_given?
      return if @mask == mask && @mask_target == target
      @mask_target&.unset_masking
      target&.set_masking self
      set_mask MaskMethod[mask || :none].to_i, target
      @mask = mask
      @mask_target = target
      update
    end

    # @public
    # Whether it should be drawn on the Scene.
    # @note Containging Scene and all lower level Scenes must be shown for the paint to be displayed on the screen.
    flag def show! value = true
      return if (c = show) == (value = block_given? ? (yield c) : value == :not ? !c : value)
      set_show value
      true
    end, def show
      get_show
    end

    # @public
    # A clipping that will be presented.
    param def clip! clip = @clip
      return yield @clip if block_given?
      clip = nil unless clip
      return if @clip == clip
      @clip&.unset_masking
      clip&.set_masking self
      set_clip clip
      @clip = clip
      update
    end

    # @endgroup

    # @public
    def bounds
      bounds = Abi::Bounds.malloc(Fiddle::RUBY_FREE)
      Abi.paint_get_bounds @pointer, bounds
      bounds
    end

    # @public
    # Detaches the Paint from the Scene.
    def detach!
      @scene&.remove_paint self
      @scene = nil
    end

    # @public
    # Attaches the Paint to the Scene.
    def attach! scene, show = true, at = nil
      @scene&.remove_paint self
      scene.put_paint self, show, at
      @scene = scene
    end

    # @public
    # Stops showing the Paint.
    def hide!
      set_show false
    end

    # @public
    # Returns the associated Window.
    def window
      @scene&.window
    end

    # @public
    # Returns the associated Action.
    def action
      @scene&.action
    end

    # @public
    # Attribute pushing method.
    # @note This definition is for error detection purposes only and should be overridden in a derived class.
    def << param
      raise_ia param
    end

    # @public 
    # Returns the Paint attributes as the Hash.
    def to_hash
      {
        x: @x,
        y: @y,
        rot: @rot,
        magx: @magx,
        magy: @magy,
        opacity: @opacity,
        blend: @blend,
      }
    end

    #internal api

    def initialize pointer
      @pointer = pointer
      @scene = nil
      @x = 0
      @y = 0
      @rot = 0
      @magx = 1
      @magy = 1
      @opacity = 255
      @blend = nil
    end

    attr :pointer
    attr_accessor :scene

    def inspect
      "#{self.class}:#{object_id}"
    end

    def set_masking scene
      @scene&.remove_paint self unless @is_mask
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

    def set_show show
      show ? @scene&.show_paint(self) : @scene&.hide_paint(self)
    end

    def get_show direct = false
      @scene&.paint_shown self, direct
    end

    def set_clip target
      Abi.paint_set_clip @pointer, target&.pointer
    end

    def set_mask mask, target
      Abi.paint_set_mask @pointer, target&.pointer, mask
    end

    def set_opacity opacity
      Abi.paint_set_opacity @pointer, opacity
    end

    def pxy
      [0, 0]
    end

    def update_transform
      Abi.paint_set_transform @pointer, *pxy, @x, @y, @rot, @magx, @magy
    end

    def set_blend blend
      Abi.paint_set_blend_method @pointer, blend
    end
  end
end
