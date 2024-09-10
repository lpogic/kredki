module Kredki

  class Fill < Pad

    aliasing def w! w = nil
      set_w_rate(w || 1.0) && begin
        update_size
        update_cars
        true
      end
    end, :width!, :w=, :width=

    aliasing def h! h = nil
      set_h_rate(h || 1.0) && begin
        update_size
        update_cars
        true
      end
    end, :height!, :h=, :height=

    aliasing def wh! w = nil, h = nil
      (set_w_rate(w || 1.0) | set_h_rate(h || w || 1.0)) && begin
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
      @w_rate = @h_rate = 1.0
    end

    def sketch p0
      parent.on_resize! do
        update_size
        update_cars
      end

      alter color: :transparent
    end

    def set_w_rate part
      if @w_rate != part
        @w_rate = part
        return true
      end
      return false
    end

    def set_h_rate part
      if @h_rate != part
        @h_rate = part
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
      set_size parent.w * @w_rate, parent.h * @h_rate
    end

    def update_cars
      w, h = *wh
      @cars.to_en{|c, b| @cars == c.next_car ? b : c.next_car }.map do |c|
        c.pad.wh! w, h
      end
    end

    def gain_point x, y, current_mouse_pad, event
      if mousy? && show?
        xp = x - self.x
        yp = y - self.y
        mouse_pad = @pads.reverse_each.find{ _1.gain_point xp, yp, @mouse_pad, event }
        prev_mouse_pad, @mouse_pad = @mouse_pad, mouse_pad
        if mouse_pad
          if current_mouse_pad == self
            current_mouse_pad.event PadMouseMoveEvent.new(event, x, y) if event
          else
            current_mouse_pad&.mouse_leaved
            mouse_entered
          end
          return true
        else
          mouse_leaved if current_mouse_pad == self
        end
      end
      return false
    end
  end
end