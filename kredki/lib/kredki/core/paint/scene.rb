require_relative 'paint'

module Kredki
  class Scene < Paint

    class PaintState
      struct :paint, :before, :after, :shown

      def inspect
        "#{self.class}:#{self.object_id}"
      end
    end
    
    def initialize
      super Abi.scene_new
      ObjectSpace.define_finalizer(self, self.class.proc.finalize(@pointer))

      @px = @py = 0
      clear!
    end

    def new_paint klass, *a, show: true, at: nil, **na, &b
      put_paint(klass.new, show, at).paint.alter(*a, **na, &b)
    end

    param def px! px = @px
      return px! yield @px if block_given?
      return if @px == px
      @px = px
      update_transform
      update
    end

    param def py! py = @py
      return py! yield @py if block_given?
      return if @py == py
      @py = py
      update_transform
      update
    end

    param def pxy! x = nil, y = nil
      return pxy! *Util.cover(yield self.pxy) if block_given?
      if x
        y ||= x
      else
        x ||= @px
        y ||= @py
      end
      return if @px == x && @py == y
      @px = x
      @py = y
      update_transform
      update
    end, def pxy
      [@px, @py]
    end

    def shape! ...
      new_paint(Shape, ...)
    end

    def rectangle! ...
      new_paint(Rectangle, ...)
    end

    def ellipse! ...
      new_paint(Ellipse, ...)
    end

    def picture! ...
      new_paint(Picture, ...)
    end

    def text! ...
      new_paint(Text, ...)
    end

    def scene! ...
      new_paint(Scene, ...)
    end

    def animation! ...
      new_animation(...)
    end

    def new_animation *a, show: true, at: nil, **na, &b
      Animation.new.attach!(self, show, at).alter(*a, **na, &b)
    end

    def clear!
      Abi.scene_remove @pointer, nil
      nil_paint = PaintState.new
      nil_paint.before = nil_paint.after = nil_paint
      @paints = {nil => nil_paint}
      update
    end

    def size
      @paints.size - 1
    end

    #intenal api

    def self.finalize pointer
      Abi.scene_delete pointer
    end

    def each_paint &b
      Enumerator.new do |e|
        state = @paints[nil].after
        while paint = state.paint
          e << paint
          state = state.after
        end
      end.each &b
    end
    
    def update_paint paint
      @scene&.update_paint self
    end

    def put_paint paint, show = true, at = nil
      paint.detach! if paint.scene
      paint.scene = self
      if show
        Abi.scene_push @pointer, paint.pointer, next_shown(at)&.pointer
        update
      end
      ats = @paints[at] || @paints[nil]
      ats.before = ats.before.after = @paints[paint] = PaintState.new paint, ats.before, ats, show
    end

    def next_shown at
      state = @paints[at]
      state = state.after while state&.paint && !state.shown
      state&.paint
    end

    def remove_paint paint
      if (state = @paints.delete paint)
        paint.scene = nil
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

    def paint_shown paint, direct
      !!@paints[paint]&.shown && (direct || get_show)
    end
  end
end
