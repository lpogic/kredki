require_relative 'paint'

module Kredki
  class Scene < Paint
    include Alterable

    class PaintState
      struct :paint, :before, :after, :shown
    end
    
    def initialize
      super Abi.scene_new
      ObjectSpace.define_finalizer(self, self.class.proc.finalize(@pointer))

      nil_paint = PaintState.new
      nil_paint.before = nil_paint.after = nil_paint
      @paints = {nil => nil_paint}
    end

    def new_paint klass, *a, show: true, at: nil, **na, &b
      push_paint(klass.new, show, at).paint.alter!(*a, **na, &b)
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
      animation.base = action
      push_paint animation.picture, show, index
      animation
    end

    def clear!
      Abi.scene_remove @pointer, nil
      @paints.clear
      update
    end

    #intenal api

    def self.finalize pointer
      Abi.scene_delete pointer
    end

    attr_accessor :base
    
    def update_paint paint
      @base&.update_paint self
    end

    def push_paint paint, show = true, at = nil
      paint.detach! if paint.base
      paint.base = self
      if show
        Abi.scene_push @pointer, paint.pointer, at&.pointer
        update
      end
      ats = @paints[at]
      ats.before = ats.before.after = @paints[paint] = PaintState.new paint, ats.before, ats, show
    end

    def remove_paint paint
      if (state = @paints.delete paint)
        paint.base = nil
        if state.shown
          Abi.scene_remove @pointer, paint.pointer
          update
        end
        state.before.after = state.after
        state.after.before = state.before
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
      state = @paints[paint]
      if state && !state.shown
        at = Enumerator.new do |e|
          n = state.after
          while n.paint
            e << n
            n = n.after
          end
        end.find{ _1.shown }
        Abi.scene_push @pointer, paint.pointer, at&.paint&.pointer
        update
        state.shown = true
      end
    end

    def paint_shown paint
      !!@paints[paint]&.shown && get_show
    end
  end
end
