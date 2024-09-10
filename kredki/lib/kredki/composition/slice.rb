module Kredki
  class Slice < Pad

    aliasing def x! x = nil
      set_x_slice((x || 0).to_f) && begin
        if sketched?
          update_size
          update_cars
        else
          set_x x
        end
        true
      end
    end, :x=

    aliasing def y! y = nil
      set_y_slice((y || 0).to_f) && begin
        if sketched?
          update_size
          update_cars
        else
          set_y y
        end
        true
      end
    end, :y=

    def xy! x = nil, y = nil
      (set_x_slice((x || 0).to_f) | set_y_slice((y || x || 0).to_f)) && begin
        if sketched?
          update_size
          update_cars
        else
          set_xy x, y
        end
        true
      end
    end

    def xy=(xy)
      case xy
      when Array
        xy! *xy
      else
        xy! xy
      end
    end

    aliasing def w! w = nil
      set_w_slice((w || 1.0).to_f) && begin
        update_size
        update_cars
        true
      end
    end, :width!, :w=, :width=

    aliasing def h! h = nil
      set_h_slice((h || 1.0).to_f) && begin
        update_size
        update_cars
        true
      end
    end, :height!, :h=, :height=

    aliasing def wh! w = nil, h = nil
      (set_w_slice((w || 1.0).to_f) | set_h_slice((h || w || 1.0).to_f)) && begin
        update_size
        update_cars
        true
      end
    end, :size!

    aliasing def wh=(wh)
      case wh
      when Array
        wh! *wh
      else
        wh! wh
      end
    end, :size=

    #internal api

    class Car
      struct :prev_car, :pad, :on_resize, :next_car
    end

    def initialize ...
      super

      @cars = Car.new
      @cars.prev_car = @cars.next_car = @cars
      @x_slice = @y_slice = 0
      @w_slice = @h_slice = 1.0
    end

    def sketch p0
      parent.on_resize! do
        update_size
        update_cars
      end

      alter color: :transparent
    end

    def set_x_slice part
      if @x_slice != part
        @x_slice = part
        return true
      end
      return false
    end

    def set_y_slice part
      if @y_slice != part
        @y_slice = part
        return true
      end
      return false
    end

    def set_w_slice part
      if @w_slice != part
        @w_slice = part
        return true
      end
      return false
    end

    def set_h_slice part
      if @h_slice != part
        @h_slice = part
        return true
      end
      return false
    end

    def push_pad pad, next_pad = nil
      super pad, next_pad

      car = Car.new @cars.prev_car, pad, next_car: @cars
      car.on_resize = pad.on_resize! do
        update_cars
      end
      @cars.prev_car = @cars.prev_car.next_car = car
      update_cars
      pad
    end

    def remove_pad pad
      super
      car = @cars.to_en{|c, b| @cars == c.next_car ? b : c.next_car}.find{ _1.pad == pad }
      if car
        car.prev_car.next_car = car.next_car
        car.next_car.prev_car = car.prev_car
        car.on_resize.detach!
        update_cars
      end
    end

    def update_size
      set_xy parent.w * @x_slice, parent.h * @y_slice
      set_size parent.w * @w_slice, parent.h * @h_slice
    end

    def update_cars
      w, h = *wh
      @cars.to_en{|c, b| @cars == c.next_car ? b : c.next_car }.map do |c|
        c.pad.wh! w, h if !c.pad.autosized?
      end
    end
    
    def autosized?
      true
    end
  end
end