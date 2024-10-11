require_relative 'has_flags'

module Kredki
  class Paint
    extend HasFlags

    def initialize pointer
      @pointer = pointer
      @owner = nil

      @x = nil
      @y = nil
      @rotation = 0

      Paint.init_flags self
    end

    aliasing def x! x 
      set_x x
    end, :x=

    def x
      @x
    end

    aliasing def y! y
      set_y y
    end, :y=

    def y
      @y
    end

    def xy! x, y
      set_xy x, y
    end

    def xy= xy
      set_xy *xy
    end

    def xy
      [@x, @y]
    end

    aliasing def rotation! rotation
      set_rotation rotation
    end, :rotation=

    def rotation
      @rotation
    end

    aliasing def scale! scale
      set_scale scale
    end, :scale=

    def bounds
      bounds = Abi::Bounds.malloc(Fiddle::RUBY_FREE)
      Abi.paint_get_bounds @pointer, bounds, 1
      bounds
    end

    aliasing def opacity! opacity
      set_opacity opacity
    end, :opacity=

    class CompositeMethod
      enum :none, :clip, :alpha, :inverse_alpha, :luma, :inverse_luma
    end

    def composite! method, mask = nil
      if !method || method == :none
        set_composite_method nil, CompositeMethod[:none].to_i
      else
        set_composite_method mask, CompositeMethod[method].to_i
      end
    end

    def clip! mask
      composite! :clip, mask
    end

    class BlendMethod
      enum :normal, :add, :screen, :multiply, :overlay, :difference,
        :exclusion, :srcover, :darken, :lighten, :colordodge, :colorburn,
        :hardlight, :softlight
    end

    aliasing def blend! blend
      set_blend BlendMethod[blend || :normal].to_i
    end, :blend=
    
    def detach!
      @owner&.remove_paint self
    end

    def attach! owner
      owner.push_paint self
    end

    def_flag :show, :set_show, :get_show

    def hide!
      set_show false
    end

    def window
      @owner&.window
    end

    def action
      @owner&.action
    end

    #internal api

    attr :pointer
    attr_accessor :owner

    def inspect
      "#{self.class}:#{object_id}"
    end

    def update
      @owner&.update_paint self
    end

    def set_show show
      show ? @owner&.show_paint(self) : @owner&.hide_paint(self)
    end

    def get_show
      @owner&.paint_shown? self
    end

    def set_composite_method mask, method
      Abi.paint_set_composite_method @pointer, mask&.pointer, method
      update
    end

    def set_x x
      x != @x && begin
        @x = x
        @x && @y && (set_translation @x, @y)
      end
    end

    def set_y y
      y != @y && begin
        @y = y
        @x && @y && (set_translation @x, @y)
      end
    end

    def set_xy x, y
      (x != @x || y != @y) && begin
        @x = x
        @y = y
        @x && @y && (set_translation @x, @y)
      end
    end

    def set_rotation rotation
      @rotation != rotation && begin
        @rotation = rotation
        Abi.paint_set_rotation @pointer, rotation
        update
        true
      end
    end

    def set_scale scale
      Abi.paint_set_scale @pointer, scale
      update
      true
    end

    def set_opacity opacity
      Abi.paint_set_opacity @pointer, opacity
      update
      true
    end

    def set_translation x, y
      Abi.paint_set_translation @pointer, x, y
      update
      true
    end

    def set_blend blend_method
      Abi.paint_set_blend_method @pointer, blend_method
      update
    end
  end
end
