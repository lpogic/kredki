module Kredki
  class Paint
    extend HasFlags
    extend HasParams

    def initialize pointer
      @pointer = pointer
      @scene = nil
      @x = 0
      @y = 0
      @rotation = 0
      @scale = 1
      @opacity = 255
      @blend = nil
      @clip = nil
    end

    def to_hash
      {
        x: @x,
        y: @y,
        rotation: @rotation,
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
      set_translation x.to_f, @y.to_f
      @x = x
      update
    end

    param def y! y
      return if @y == y
      set_translation @x.to_f, y.to_f
      @y = y
      update
    end

    param def xy! x, y = nil
      y ||= x
      return if @x == x && @y == y
      set_translation x.to_f, y.to_f
      @x = x
      @y = y
      update
    end, def xy
      [@x, @y]
    end

    param def rotation! rotation
      return if @rotation == rotation
      set_rotation rotation.to_f
      @rotation = rotation
      update
    end

    param def scale! scale
      return if @scale == scale
      set_scale scale.to_f
      @scale = scale
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
      @clip&.unset_self_clip
      clip&.set_self_clip self
      set_clip clip&.pointer
      update
    end
    
    def detach!
      @scene&.remove_paint self
      @scene = nil
    end

    def attach! scene
      @scene&.remove_paint self
      scene.put_paint self
      @scene = scene
    end

    flag :show, set: :set_show, get: :get_show, test: false

    def show? direct = false
      get_show direct
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

    def update
      @scene&.update_paint self
      true
    end

    def set_show show
      show ? @scene&.show_paint(self) : @scene&.hide_paint(self)
    end

    def get_show direct = true
      @scene&.paint_shown self, direct
    end

    # def set_composite_method mask, method
    #   Abi.paint_set_composite_method @pointer, mask&.pointer, method
    #   update
    # end

    def set_clip mask
      Abi.paint_set_clip @pointer, mask
    end

    def set_rotation rotation
      Abi.paint_set_rotation @pointer, rotation
    end

    def set_scale scale
      Abi.paint_set_scale @pointer, scale
    end

    def set_opacity opacity
      Abi.paint_set_opacity @pointer, opacity
    end

    def set_translation x, y
      Abi.paint_set_translation @pointer, x, y
    end

    def set_blend blend
      Abi.paint_set_blend_method @pointer, blend
    end
  end
end
