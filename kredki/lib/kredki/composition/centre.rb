module Kredki

  class Centre < Pad
    class Car
      struct :prev_car, :pad, :on_resize, :next_car
    end

    def initialize ...
      super

      @cars = Car.new
      @cars.prev_car = @cars.next_car = @cars
    end

    def sketch p0
      parent.on_resize! do
        wh! *parent.wh
        update_cars
      end.call

      alter color: :transparent
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

    def update_cars
      w, h = *wh
      @cars.to_en{|c, b| @cars == c.next_car ? b : c.next_car }.map do |c|
        c.pad.xy! (w - c.pad.w) / 2, (h - c.pad.h) / 2
      end
    end

    def autosized?
      true
    end
  end
end