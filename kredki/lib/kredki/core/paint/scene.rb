require_relative 'paint'

module Kredki
  class Scene < Paint

    # Set pivot point position along the X axis.
    def pivot_x! pivot_x = @pivot_x
      return pivot_x! yield @pivot_x if block_given?
      return if @pivot_x == pivot_x
      @pivot_x = pivot_x
      update_transform
      update
    end

    # See #pivot_x!.
    def pivot_x= param
      send_ahp :pivot_x!, param
    end

    # Get pivot point position along the X axis.
    def pivot_x
      @pivot_x
    end

    # Set pivot point position along the Y axis.
    def pivot_y! pivot_y = @pivot_y
      return pivot_y! yield @pivot_y if block_given?
      return if @pivot_y == pivot_y
      @pivot_y = pivot_y
      update_transform
      update
    end

    # See #pivot_y!.
    def pivot_y= param
      send_ahp :pivot_y!, param
    end

    # Get pivot point position along the Y axis.
    def pivot_y
      @pivot_y
    end

    # Set pivot point position along X and Y axes.
    def pivot_xy! pivot_x = @pivot_x, pivot_y = pivot_x
      return send_ahp :pivot_xy!, yield(self.pivot_xy) if block_given?
      return if @pivot_x == pivot_x && @pivot_y == pivot_y
      @pivot_x = pivot_x
      @pivot_y = pivot_y
      update_transform
      update
    end

    # See #pivot_xy!.
    def pivot_xy= param
      send_ahp :pivot_xy!, param
    end

    # Get pivot point position along X and Y axes.
    def pivot_xy
      [@pivot_x, @pivot_y]
    end

    # Create new attached Kredki::Shape.
    def shape! ...
      new_paint(Shape, ...)
    end

    # Create new attached Kredki::Rectangle.
    def rectangle! ...
      new_paint(Rectangle, ...)
    end

    # Create new attached Kredki::Ellipse.
    def ellipse! ...
      new_paint(Ellipse, ...)
    end

    # Create new attached Kredki::Picture.
    def picture! ...
      new_paint(Picture, ...)
    end

    # Create new attached Kredki::Text.
    def text! ...
      new_paint(Text, ...)
    end

    # Create new attached Kredki::Scene.
    def scene! ...
      new_paint(Scene, ...)
    end

    # Create new attached Kredki::Animation.
    def animation! ...
      new_animation(...)
    end

    # Detach all paints.
    def clear!
      Pastele.scene_remove @pointer, nil
      nil_paint = PaintState.new nil, nil, nil, nil
      nil_paint.before = nil_paint.after = nil_paint
      @paints = {nil => nil_paint}
      update
    end

    # Total attached paints.
    def size
      @paints.size - 1
    end

    # :section: LEVEL 2

    class PaintState

      def initialize paint, before, after, shown
        @paint = paint
        @before = before
        @after = after
        @shown = shown
      end
      
      attr_accessor :paint
      attr_accessor :before
      attr_accessor :after
      attr_accessor :shown

      def inspect
        "#{self.class}:#{self.object_id}"
      end
    end
    
    def initialize
      super Pastele.scene_new
      ObjectSpace.define_finalizer(self, Scene.finalizer(@pointer))

      @pivot_x = @pivot_y = 0
      clear!
    end

    def self.finalizer pointer
      proc{ Pastele.scene_delete pointer }
    end

    def new_paint klass, *a, show: true, at: nil, **na, &b
      put_paint(klass.new, show, at).paint.alter(*a, **na, &b)
    end

    def new_animation *a, show: true, at: nil, **na, &b
      Animation.new.attach(self, show, at).alter(*a, **na, &b)
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
      paint.detach if paint.scene
      paint.scene = self
      if show
        Pastele.scene_add @pointer, paint.pointer, next_shown(at)&.pointer
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
          Pastele.scene_remove @pointer, paint.pointer
          update
        end
        state.before.after = state.after
        state.after.before = state.before
      end
      paint
    end

    def hide_paint paint
      if (state = @paints[paint])&.shown
        Pastele.scene_remove @pointer, paint.pointer
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
        Pastele.scene_add @pointer, paint.pointer, at&.paint&.pointer
        update
        state.shown = true
      end
    end

    def paint_shown paint, direct
      !!@paints[paint]&.shown && (direct || get_show)
    end
  end
end
