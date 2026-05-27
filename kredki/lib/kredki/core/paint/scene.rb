require_relative 'paint'

module Kredki
  class Scene < Paint

    feature :pivot_x # Pivot point position along the X axis.

    def set_pivot_x pivot_x
      return if @pivot_x == pivot_x
      @pivot_x = pivot_x
      update_transform
      update
    end
    
    def pivot_x
      @pivot_x
    end

    feature :pivot_y # Pivot point position along the Y axis.

    def set_pivot_y pivot_y
      return if @pivot_y == pivot_y
      @pivot_y = pivot_y
      update_transform
      update
    end

    def pivot_y
      @pivot_y
    end

    feature :pivot # Pivot point position along X and Y axes.

    def set_pivot pivot_x, pivot_y = pivot_x
      return if @pivot_x == pivot_x && @pivot_y == pivot_y
      @pivot_x = pivot_x
      @pivot_y = pivot_y
      update_transform
      update
    end

    def pivot
      [@pivot_x, @pivot_y]
    end

    # Create new attached Kredki::Shape.
    def new_shape ...
      new_paint(Shape, ...)
    end

    # Create new attached Kredki::Rectangle.
    def new_rectangle ...
      new_paint(Rectangle, ...)
    end

    # Create new attached Kredki::Ellipse.
    def new_ellipse ...
      new_paint(Ellipse, ...)
    end

    # Create new attached Kredki::Picture.
    def new_picture ...
      new_paint(Picture, ...)
    end

    # Create new attached Kredki::Text.
    def new_text ...
      new_paint(Text, ...)
    end

    # Create new attached Kredki::Scene.
    def new_scene ...
      new_paint(Scene, ...)
    end

    # Create new attached Kredki::Animation.
    def new_animation *a, hidden: false, at: nil, **ka, &b
      Animation.new.attach(self, hidden, at).set(*a, **ka, &b)
    end

    # Clear all scene effects.
    def clear_effects
      Pastele.scene_clear_effects @pointer
      update
    end

    # Add gaussian blur scene effect.
    def gaussian_blur sigma, direction = :both, border = :wrap, quality = 100
      direction = case direction
      when :both, 0 then 0
      when :x, 1 then 1
      when :y, 2 then 2
      else raise_ia direction
      end
      border = case border
      when :duplicate, 0 then 0
      when :wrap, 1 then 1
      end
      Pastele.scene_add_gaussian_blur @pointer, sigma, direction, border, quality
      update
    end

    # Add drop shadow scene effect.
    def drop_shadow color:, angle: 0, distance: 0, blur: 5, quality: 10
      Pastele.scene_add_drop_shadow @pointer, *Kredki.color(color).to_rgba, angle, distance, blur, quality
      update
    end

    # Add fill scene effect.
    def fill *a
      Pastele.scene_add_fill @pointer, *Kredki.color(a.uncover).to_rgba
      update
    end

    # Add tint scene effect.
    def tint black:, white:, intensity: 100.0
      Pastele.scene_add_tint @pointer, *Kredki.color(black).to_rgb, *Kredki.color(white).to_rgb, intensity
      update
    end

    # Add tritone scene effect.
    def tritone shadow:, midtone:, highlight:, blend: 255
      Pastele.scene_add_tritone @pointer, *Kredki.color(shadow).to_rgb, *Kredki.color(midtone).to_rgb, *Kredki.color(highlight).to_rgb, blend
      update
    end

    # Detach all paints.
    def clear
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

      def initialize paint, before, after, hidden
        @paint = paint
        @before = before
        @after = after
        @hidden = hidden
      end
      
      attr_accessor :paint
      attr_accessor :before
      attr_accessor :after
      attr_accessor :hidden

      def inspect
        "#{self.class}:#{self.object_id}"
      end
    end
    
    def initialize
      super Pastele.scene_new
      ObjectSpace.define_finalizer(self, Scene.finalizer(@pointer))

      @pivot_x = @pivot_y = 0
      clear
    end

    def self.finalizer pointer
      proc{ Pastele.scene_delete pointer }
    end

    def new_paint klass, *a, hidden: false, at: nil, **ka, &b
      put_paint(klass.new, hidden, at).paint.set(*a, **ka, &b)
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

    def put_paint paint, hidden = false, at = nil
      paint.detach if paint.scene
      paint.scene = self
      unless hidden
        Pastele.scene_add @pointer, paint.pointer, next_shown(at)&.pointer
        update
      end
      ats = @paints[at] || @paints[nil]
      ats.before = ats.before.after = @paints[paint] = PaintState.new paint, ats.before, ats, hidden
    end

    def next_shown at
      state = @paints[at]
      state = state.after while state&.paint && state.hidden
      state&.paint
    end

    def delete_paint paint
      if (state = @paints.delete paint)
        paint.scene = nil
        unless state.hidden
          Pastele.scene_remove @pointer, paint.pointer
          update
        end
        state.before.after = state.after
        state.after.before = state.before
      end
      paint
    end

    def hide_paint paint
      state = @paints[paint]
      if state && !state.hidden
        Pastele.scene_remove @pointer, paint.pointer
        update
        state.hidden = true
      end
    end

    def show_paint paint
      state = @paints[paint]
      if state && state.hidden
        at = state
        at = at.after while at.after&.hidden
        Pastele.scene_add @pointer, paint.pointer, at.after&.paint&.pointer
        update
        state.hidden = false
      end
    end

    def renew_paint paint, old_pointer, new_pointer
      state = @paints[paint]
      if state && !state.hidden
        Pastele.scene_add @pointer, new_pointer, old_pointer
        Pastele.scene_remove @pointer, old_pointer
      end
    end

    def paint_scenic paint
      state = @paints[paint]
      state && !state.hidden
    end

    def paint_displayed paint
      paint_scenic paint and displayed
    end
  end
end
