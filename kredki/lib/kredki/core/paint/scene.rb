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
    def new_animation *a, at: nil, **ka, &b
      Animation.new.attach(self, at).set(*a, **ka, &b)
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
      @paints = []
      update
    end

    # Total attached paints.
    def size
      @paints.size
    end

    # :section: LEVEL 2
    
    def initialize
      super Pastele.scene_new
      ObjectSpace.define_finalizer(self, Scene.finalizer(@pointer))

      @pivot_x = @pivot_y = 0
      clear
    end

    def self.finalizer pointer
      proc{ Pastele.scene_delete pointer }
    end

    def new_paint klass, *a, at: nil, **ka, &b
      put_paint(klass.new, at).set(*a, **ka, &b)
    end

    def paints
      @paints
    end
    
    def update_paint paint
      @scene&.update_paint self
    end

    def put_paint paint, at = nil
      paint.detach if paint.scene
      paint.scene = self
      if at
        at_index = @paints.find_index{|it| it == at }
        if at_index
          Pastele.scene_add @pointer, paint.pointer, at.pointer
          update
          @paints.insert at_index, paint
          return
        end
      end
      Pastele.scene_add @pointer, paint.pointer, nil
      update
      @paints.append paint
      paint
    end

    def delete_paint paint
      if @paints.delete paint
        paint.scene = nil
        Pastele.scene_remove @pointer, paint.pointer
        update
      end
      paint
    end

    def renew_paint paint, old_pointer, new_pointer
      Pastele.scene_add @pointer, new_pointer, old_pointer
      Pastele.scene_remove @pointer, old_pointer
    end
  end
end
