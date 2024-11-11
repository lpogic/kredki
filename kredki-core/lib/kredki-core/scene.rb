require_relative 'paint'

module Kredki
  class Scene < Paint
    include Alterable

    class PaintState
      struct :paint, :index, :shown
    end

    def initialize
      super Abi.scene_new
      ObjectSpace.define_finalizer(self, self.class.proc.finalize(@pointer))

      @paints = {}
    end

    def new_paint klass, *a, _show: true, _index: nil, **na, &b
      push_paint(klass.new, _show, _index).paint.alter!(*a, **na, &b)
    end
    
    def def_paint name, klass = nil, &block
      if block
        Scene.define_method name do |*a, **na, &b|
          paint = instance_exec self, a, b, **na, &block
          paint.alter! *a, **na, &b if klass
          paint
        end
      else
        Scene.define_method name do |*a, **na, &b|
          new_paint klass, *a, **na, &b
        end
      end
    end

    def self.def_paint name, klass = nil, &block
      if block
        define_method name do |*a, **na, &b|
          paint = instance_exec self, a, b, **na, &block
          paint.alter! *a, **na, &b if klass
          paint
        end
      else
        define_method name do |*a, **na, &b|
          new_paint klass, *a, **na, &b
        end
      end
    end

    def new_animation show, index
      animation = Animation.new
      animation.owner = action
      push_paint animation.picture, show, index
      animation
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
    
    def paint_hash
      @paints
    end

    def update_paint paint
      @owner&.update_paint self
    end

    def push_paint paint, show = true, index = nil
      paint.detach! if paint.owner
      paint.owner = self
      index = @paints.size if !index || index > @paints.size
      index = @paints.size + index + 1 if index < 0
      if show
        if index < @paints.size
          Abi.scene_insert @pointer, @paints.each_value.count{|state| state.shown && state.index < index }, paint.pointer
        else
          Abi.scene_push @pointer, paint.pointer
        end
        update
      end
      @paints.each_value{|paint| paint.index += 1 if paint.index >= index } if index < @paints.size
      @paints[paint] = PaintState.new paint, index, show
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
          Abi.scene_insert @pointer, @paints.each_value.count{|s| s.shown && s.index < state.index }, paint.pointer
        else
          Abi.scene_push @pointer, paint.pointer
        end
        update
        state.shown = true
      end
    end

    def paint_shown? paint
      !!@paints[paint]&.shown && show?
    end

    def paint_index paint
      @paints[paint]&.index
    end
  end
end
