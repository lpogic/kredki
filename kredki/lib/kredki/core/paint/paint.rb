# @public
module Kredki
  # @public
  class Paint
    extend HasParams

    def initialize pointer
      @pointer = pointer
      @scene = nil
      @x = 0
      @y = 0
      @a = 0
      @dx = 1
      @dy = 1
      @opacity = 255
      @blend = nil
    end

    def to_hash
      {
        x: @x,
        y: @y,
        a: @a,
        dx: @dx,
        dy: @dy,
        opacity: @opacity,
        blend: @blend,
      }
    end

    def << param
      raise_ia param
    end

    # @group Parameters

    # @public
    # Sets position along the X axis.
    param def x! x = @x
      return x! yield @x if block_given?
      return if @x == x
      @x = x
      update_transform
      update
    end

    # @public
    # Sets position along the Y axis.
    param def y! y = @y
      return y! yield @y if block_given?
      return if @y == y
      @y = y
      update_transform
      update
    end

    # @public
    # Sets position along X and Y axes.
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
    # Sets rotation aroud pivot point.
    param def a! a = @a
      return a! yield @a if block_given?
      return if @a == a
      @a = a
      update_transform
      update
    end

    # @public
    # Sets scale along the X axis.
    param def dx! dx = @dx
      return dx! yield @dx if block_given?
      return if @dx == dx
      @dx = dx
      update_transform
      update
    end

    # @public
    # Sets scale along the Y axis.
    param def dy! dy = @dy
      return dy! yield @dy if block_given?
      return if @dy == dy
      @dy = dy
      update_transform
      update
    end

    # @public
    # Sets scale along X and Y axes.
    # @param x [Numeric] Paint scale along the X axis.
    # @param y [Numeric, nil] Paint scale along the Y axis.
    param def d! dx = nil, dy = nil
      return d! *Util.cover(yield self.d) if block_given?
      if dx
        dy ||= dx
      else
        dx ||= @dx
        y ||= @dy
      end
      return if @dx == dx && @dy == dy
      @dx = dx
      @dy = dy
      update_transform
      update
    end, def d
      [@dx, @dy]
    end

    # @endgroup

    def bounds
      bounds = Abi::Bounds.malloc(Fiddle::RUBY_FREE)
      Abi.paint_get_bounds @pointer, bounds
      bounds
    end

    param def opacity! opacity
      return if @opacity == opacity
      set_opacity opacity.to_i
      @opacity = opacity
      update
    end

    class BlendMethod
      enum :normal, :add, :screen, :multiply, :overlay, :difference,
        :exclusion, :srcover, :darken, :lighten, :colordodge, :colorburn,
        :hardlight, :softlight
    end

    param def blend! blend = @blend
      return blend! yield @blend if block_given?
      return if @blend == blend
      set_blend BlendMethod[blend || :normal].to_i
      @blend = blend
      update
    end

    def clip! clip
      clip = nil unless clip
      return if @clip == clip
      @clip&.unset_masking
      clip&.set_masking self
      set_clip clip
      @clip = clip
      update
    end

    class MaskMethod
      enum :none, :alpha, :inv_alpha, :luma, :inv_luma
      # :add, :substract, :intersect, :difference, :lighten, :darken
    end

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
    
    def detach!
      @scene&.remove_paint self
      @scene = nil
    end

    def attach! scene, show = true, at = nil
      @scene&.remove_paint self
      scene.put_paint self, show, at
      @scene = scene
    end

    # @group Parameters

    # @public
    # Set whether paint should be drawn on the scene.
    # @note All lower level scenes must be shown for the paint to be displayed on the screen.
    flag def show! value = true
      return if (c = show) == (value = block_given? ? (yield c) : value == :not ? !c : value)
      set_show value
      true
    end, def show
      get_show
    end

    # @endgroup

    def hide!
      set_show false
    end

    def window
      @scene&.window
    end

    def action
      @scene&.action
    end

    #internal api

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
      Abi.paint_set_transform @pointer, *pxy, @x, @y, @a, @dx, @dy
    end

    def set_blend blend
      Abi.paint_set_blend_method @pointer, blend
    end
  end
end
