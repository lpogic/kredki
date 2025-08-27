module Kredki
  class Paint
    extend HasParams

    def initialize pointer
      @pointer = pointer
      @scene = nil
      @x = 0
      @y = 0
      @spin = 0
      @scale = 1
      @opacity = 255
      @blend = nil
    end

    def to_hash
      {
        x: @x,
        y: @y,
        spin: @spin,
        scale: @scale,
        opacity: @opacity,
        blend: @blend,
      }
    end

    def << param
      raise_ia param
    end

    param def x! x
      return if @x == x
      @x = x
      update_transform
      update
    end

    param def y! y
      return if @y == y
      @y = y
      update_transform
      update
    end

    param def xy! x, y = x
      return if @x == x && @y == y
      @x = x
      @y = y
      update_transform
      update
    end, def xy
      [@x, @y]
    end

    param def spin! spin
      return if @spin == spin
      @spin = spin
      update_transform
      update
    end

    param def scale! scale
      return if @scale == scale
      @scale = scale
      update_transform
      update
    end

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

    param def blend! blend
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

    param def mask! mask, target = nil
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

    flag def show! s = true
      c, n = show? s
      return if c == n
      set_show n
      true
    end, def show
      get_show
    end

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
      Abi.paint_set_transform @pointer, *pxy, @x, @y, @spin, @scale
    end

    def set_blend blend
      Abi.paint_set_blend_method @pointer, blend
    end
  end
end
