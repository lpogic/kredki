require_relative 'slide'

module Kredki
  class Train < Pad

    class Car
      struct :prev_car, :pad, :on_resize, :next_car
    end

    def initialize ...
      super

      @cars = Car.new
      @cars.prev_car = @cars.next_car = @cars
      @space = 0
      alter color: :transparent
    end

    aliasing def space! space
      @space != space && begin
        @space = space
        update_cars
        true
      end
    end, :space=

    def space
      @space
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
  end

  class XTrain < Train
    def update_cars
      offset = 0
      max_h = @cars.to_en{|c, b| @cars == c.next_car ? b : c.next_car }.map do |c|
        c.pad.x = offset
        offset += c.pad.w + @space
        c.pad.h
      end.max
      offset -= @space if offset > 0
      if h!(max_h || 100) | w!(offset)
        event PadResizeEvent.new
      end
    end
  end

  class YTrain < Train
    def update_cars
      offset = 0
      max_w = @cars.to_en{|c, b| @cars == c.next_car ? b : c.next_car }.map do |c|
        c.pad.y = offset
        offset += c.pad.h + @space
        c.pad.w
      end.max
      offset -= @space if offset > 0
      if w!(max_w || 100) | h!(offset)
        event PadResizeEvent.new
      end
    end
  end
end