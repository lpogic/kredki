require_relative 'alterable'
require_relative 'paint'

module Kredki
  class Scene < Paint
    include Alterable

    def initialize **params, &block
      super Abi.scene_new
      ObjectSpace.define_finalizer(self, self.class.proc.finalize(@pointer))

      @paints = {}

      alter **params, &block
    end

    def shape! ...
      push_paint(Shape.new).alter(...)
    end

    def ellipse! ...
      push_paint Ellipse.new(...)
    end

    def rectangle! ...
      push_paint Rectangle.new(...)
    end

    def picture! ...
      push_paint Picture.new(...)
    end

    def text! ...
      push_paint Text.new(...)
    end

    def animation! ...
      animation = Animation.new(...)
      animation.owner = action
      push_paint animation.picture
      animation
    end

    def scene! ...
      push_paint(Scene.new).alter(...)
    end

    def clear!
      Abi.scene_clear @pointer, 0
      @paints.clear
      update
    end

    #intenal api

    def self.finalize pointer
      Abi.scene_delete pointer
    end

    attr_accessor :owner

    def update_paint paint
      @owner&.update_paint self
    end

    def push_paint paint, show = true
      paint.remove if paint.owner
      paint.owner = self
      if show
        Abi.scene_push @pointer, paint.pointer
        @paints[paint] = :shown
        update
      else
        @paints[paint] = :hidden
      end
      paint
    end

    def remove_paint paint
      if @paints.delete paint
        paint.owner = nil
        Abi.scene_remove @pointer, paint.pointer
        update
      end
      paint
    end

    def hide_paint paint
      if @paints[paint] == :shown
        Abi.scene_remove @pointer, paint.pointer
        @paints[paint] = :hidden
        update
      end
    end

    def show_paint paint
      if @paints[paint] == :hidden
        Abi.scene_push @pointer, paint.pointer
        @paints[paint] = :shown
        update
      end
    end

    def paint_shown? paint
      @paints[paint] == :shown
    end
  end
end
