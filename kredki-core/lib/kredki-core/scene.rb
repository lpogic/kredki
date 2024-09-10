require_relative 'alterable'
require_relative 'paint'

module Kredki
  class Scene < Paint
    include Alterable

    class PaintState
      struct :index, :shown
    end

    def initialize x: 0, y: 0, **params, &block
      super Abi.scene_new
      ObjectSpace.define_finalizer(self, self.class.proc.finalize(@pointer))

      @paints = {}

      alter x:, y:, **params, &block
    end

    def shape! ...
      push_paint(Shape.new).alter(...)
    end

    def ellipse! ...
      push_paint(Ellipse.new).alter(...)
    end

    def rectangle! ...
      push_paint(Rectangle.new).alter(...)
    end

    def picture! ...
      push_paint(Picture.new).alter(...)
    end

    def text! ...
      push_paint(Text.new).alter(...)
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

    def push_paint paint, show = true, index = nil
      paint.detach! if paint.owner
      paint.owner = self
      index = @paints.size if !index || index > @paints.size
      index = @paints.size - index + 1 if index < 0
      if show
        if index < @paints.size
          Abi.scene_insert @pointer, index, paint.pointer
        else
          Abi.scene_push @pointer, paint.pointer
        end
        update
      end
      @paints.each_value{|paint| paint.index += 1 if paint.index >= index } if index < @paints.size
      @paints[paint] = PaintState.new index, show
      paint
    end

    def remove_paint paint
      if (state = @paints.delete paint)
        paint.owner = nil
        if state.shown
          Abi.scene_remove @pointer, paint.pointer
          update
        end
        @paints.each_value{|paint| paint.index -= 1 if paint.index > state.index }
      end
      paint
    end

    def hide_paint paint
      if (state = @paints[paint])&.shown
        Abi.scene_remove @pointer, paint.pointer
        update
        state.shown = false
      end
    end

    def show_paint paint
      if (state = @paints[paint])&.shown.!
        if state.index + 1 < @paints.size
          Abi.scene_insert @pointer, index, paint.pointer
        else
          Abi.scene_push @pointer, paint.pointer
        end
        update
        state.shown = true
      end
    end

    def paint_shown? paint
      !!@paints[paint]&.shown
    end
  end
end
