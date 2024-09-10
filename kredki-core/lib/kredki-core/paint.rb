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

    aliasing def xy! x, y
      set_xy x, y
    end, :xy=

    def rotation! rotation
      set_rotation rotation
    end

    alias_method :rotation=, :rotation!

    def rotation
      @rotation
    end

    def scale! scale
      set_scale scale
    end

    alias_method :scale=, :scale!
    
    def bounds
      bounds = Abi::Bounds.malloc(Fiddle::RUBY_FREE)
      Abi.paint_get_bounds @pointer, bounds, 1
      bounds
    end

    def opacity! opacity
      set_opacity opacity
    end

    alias_method :opacity=, :opacity!

    class CompositeMethod
      enum :none, :clip, :alpha, :inverse_alpha, :luma, :inverse_luma
    end

    def composite! method, mask
      set_composite_method mask, CompositeMethod[method].to_i
    end

    def clip! mask
      composite! :clip, mask
    end

    class BlendMethod
      enum :normal, :add, :screen, :multiply, :overlay, :difference,
        :exclusion, :srcover, :darken, :lighten, :colordodge, :colorburn,
        :hardlight, :softlight
    end

    def blend! blend
      set_blend BlendMethod[blend || :normal].to_i
    end
    
    alias_method :blend=, :blend!

    def detach!
      @owner&.remove_paint self
      @owner = nil
    end

    flag :show, :set_show, :get_show

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
      Abi.paint_set_composite_method @pointer, mask.pointer, method
      update
    end

    def set_x x
      if x != @x
        @x = x
        if @x && @y
          set_translation @x, @y
          return true
        end
      end
      return false
    end

    def set_y y
      if y != @y
        @y = y
        if @x && @y
          set_translation @x, @y
          return true
        end
      end
      return false
    end

    def set_xy x, y
      if x != @x || y != @y
        @x = x
        @y = y
        if @x && @y
          set_translation @x, @y
          return true
        end
      end
      return false
    end

    def set_rotation rotation
      if @rotation != rotation
        @rotation = rotation
        Abi.paint_set_rotation @pointer, rotation
        update
        return true
      end
      return false
    end

    def set_scale scale
      Abi.paint_set_scale @pointer, scale
      update
    end

    def set_opacity opacity
      Abi.paint_set_opacity @pointer, opacity
      update
    end

    def set_translation x, y
      Abi.paint_set_translation @pointer, x, y
      update
    end

    def set_blend blend_method
      Abi.paint_set_blend_method @pointer, blend_method
      update
    end
  end
end
