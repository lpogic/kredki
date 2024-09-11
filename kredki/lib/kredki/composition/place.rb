module Kredki
  class Place < Pad

    aliasing def x! x = :center, &block
      if sketched?
        if block
          set_x_place &block
        else
          case x
          when :c, :center
            set_x_place{|w, pw| (w - pw) / 2 }
          when :r, :right, :e, :end
            set_x_place{|w, pw| w - pw }
          when :l, :left, :s, :start
            set_x_place{|w, pw| 0 }
          when Proc
            set_x_place &x
          else
            xc! x
          end
        end
      else
        set_x x
      end
    end, :x=

    aliasing def y! y = :center, &block
      if sketched?
        if block
          set_y_place &block
        else
          case y
          when :c, :center
            set_y_place{|h, ph| (h - ph) / 2 }
          when :b, :bottom, :e, :end
            set_y_place{|h, ph| h - ph }
          when :t, :top, :s, :start
            set_y_place{|h, ph| 0 }
          when Proc
            set_y_place &y
          else
            yc! y
          end
        end
      else
        set_y y
      end
    end, :y=

    def xy! x = :center, y = nil
      x! x
      y! y || x
    end

    def xy=(xy)
      case xy
      when Array
        xy! *xy
      else
        xy! xy
      end
    end

    aliasing def l! l = 0
      set_x_place{ l }
    end, :l=, :left!, :left=

    aliasing def t! t = 0
      set_y_place{ t }
    end, :t=, :top!, :top=

    aliasing def r! r = 0
      set_x_place{|w, pw| w - pw - r }
    end, :r=, :right!, :right=

    aliasing def b! b = 0
      set_y_place{|h, ph| h - ph - b }
    end, :b=, :bottom!, :bottom=
    
    aliasing def c! x = 0, y = nil
      xc! x
      yx! y || x
    end, :center!

    aliasing def c=(xy)
      case xy
      when Array
        c! *xy
      else
        c! xy
      end
    end, :center=

    aliasing def cx! x = 0
      set_x_place{|w, pw| (w - pw) / 2 + x } && begin
        update_cars
      end
    end, :cx=, :center_x!, :center_x=

    aliasing def cy! y = 0
      set_y_place{|h, ph| (h - ph) / 2 + y } && begin
        update_cars
      end
    end, :cy=, :center_y!, :center_y=

    #internal api

    class Car
      struct :prev_car, :pad, :on_resize, :next_car
    end

    def initialize ...
      super

      @cars = Car.new
      @cars.prev_car = @cars.next_car = @cars
      @x_place = @y_place = proc{|a, pa| (a - pa) / 2 }
    end

    def sketch p0
      parent.on_resize! do
        update_size
        update_cars
      end.call

      alter color: :transparent
    end
    
    def set_x_place &place
      @x_place = place
      return true
    end

    def set_y_place &place
      @y_place = place
      return true
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
      car = @cars.to_en{|c, b| @cars == c.next_car ? b : c.next_car }.find{ _1.pad == pad }
      if car
        car.prev_car.next_car = car.next_car
        car.next_car.prev_car = car.prev_car
        car.on_resize.detach!
        update_cars
      end
    end

    def update_size
      set_size parent.w, parent.h
    end

    def update_cars
      w, h = *wh
      @cars.to_en{|c, b| @cars == c.next_car ? b : c.next_car }.map do |c|
        c.pad.xy! @x_place.call(w, c.pad.w), @y_place.call(h, c.pad.h)
      end
    end
    
    def autosized?
      true
    end
  end
end