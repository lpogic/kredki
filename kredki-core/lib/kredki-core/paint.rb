require_relative 'flagship'

module Kredki
  class Paint
    extend Flagship

    def initialize pointer
      @pointer = pointer
      @owner = nil

      @x = 0
      @y = 0
      @rotation = 0
    end

    aliasing def x! x 
      @x != x and @y and set_translation x, @y
    end, :x=

    def x
      @x
    end

    aliasing def y! y
      @y != y and @x and set_translation @x, y
    end, :y=

    def y
      @y
    end

    def xy! x, y = nil
      y ||= x
      @x != x || @y != y and set_translation x, y
    end

    def xy= xy
      xy! *xy
    end

    def xy
      [@x, @y]
    end

    aliasing def rotation! rotation
      @rotation != rotation and set_rotation rotation
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

    # class CompositeMethod
    #   enum :none, :clip, :alpha, :inverse_alpha, :luma, :inverse_luma
    # end

    # def composite! method, mask = nil
    #   if !method || method == :none
    #     set_composite_method nil, CompositeMethod[:none].to_i
    #   else
    #     set_composite_method mask, CompositeMethod[method].to_i
    #   end
    # end

    def clip! mask
      set_clip mask || nil
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

    def_flag :show, set: :set_show, get: :get_show

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
      true
    end

    def set_show show
      show ? @owner&.show_paint(self) : @owner&.hide_paint(self)
    end

    def get_show
      @owner&.paint_shown? self
    end

    # def set_composite_method mask, method
    #   Abi.paint_set_composite_method @pointer, mask&.pointer, method
    #   update
    # end

    def set_clip mask
      Abi.paint_set_clip @pointer, mask&.pointer
      update
    end

    def set_rotation rotation
      Abi.paint_set_rotation @pointer, rotation
      @rotation = rotation
      update
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
      @x = x
      @y = y
      update
    end

    def set_blend blend_method
      Abi.paint_set_blend_method @pointer, blend_method
      update
    end
  end
end
