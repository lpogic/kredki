module Kredki
  module UI
    class Place < Pad

      # aliasing def x! x = :center, &block
      #   if sketched?
      #     if block
      #       set_x_place &block
      #     else
      #       case x
      #       when :c, :center
      #         set_x_place{|w, pw| (w - pw) / 2 }
      #       when :r, :right, :e, :end
      #         set_x_place{|w, pw| w - pw }
      #       when :l, :left, :s, :start
      #         set_x_place{|w, pw| 0 }
      #       when Proc
      #         set_x_place &x
      #       else
      #         cx! x
      #       end
      #     end
      #   else
      #     set_x x
      #   end
      # end, :x=

      # aliasing def y! y = :center, &block
      #   if sketched?
      #     if block
      #       set_y_place &block
      #     else
      #       case y
      #       when :c, :center
      #         set_y_place{|h, ph| (h - ph) / 2 }
      #       when :b, :bottom, :e, :end
      #         set_y_place{|h, ph| h - ph }
      #       when :t, :top, :s, :start
      #         set_y_place{|h, ph| 0 }
      #       when Proc
      #         set_y_place &y
      #       else
      #         cy! y
      #       end
      #     end
      #   else
      #     set_y y
      #   end
      # end, :y=

      # def xy! x = :center, y = nil
      #   x! x
      #   y! y || x
      # end

      # def xy=(xy)
      #   case xy
      #   when Array
      #     xy! *xy
      #   else
      #     xy! xy
      #   end
      # end

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
        @parent_resize = nil
      end

      def sketch p0
        super

        body.hide!
      end

      def set_parent parent
        super
        @parent_resize&.detach!
        @parent_resize = parent&.on_resize! do
          update_size
          update_cars
        end
        @parent_resize&.resolve
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

        car = Car.new @cars.prev_car, pad, pad.on_resize!{ update_cars }, @cars
        @cars.prev_car = @cars.prev_car.next_car = car
        update_cars
        pad
      end

      def remove_pad pad, transfer
        super
        car = @cars.to_en{|c, b| @cars == c.next_car ? b : c.next_car }.find{ _1.pad == pad }
        if car
          car.prev_car.next_car = car.next_car
          car.next_car.prev_car = car.prev_car
          car.on_resize.detach!
        end
      end

      def update_size
        set_size parent.reduce_child_w? ? w : parent.w, parent.reduce_child_h? ? h : parent.h
      end

      def update_cars
        w, h = *wh
        alter_size = false
        if parent.reduce_child_w?
          w = @cars.to_en{|c, b| @cars == c.next_car ? b : c.next_car }.map{|c| c.pad.w }.max
          alter_size = true if w
        end
        if parent.reduce_child_h?
          h = @cars.to_en{|c, b| @cars == c.next_car ? b : c.next_car }.map{|c| c.pad.h }.max
          alter_size = true if h
        end
        set_size w, h if alter_size
        @cars.to_en{|c, b| @cars == c.next_car ? b : c.next_car }.map do |c|
          c.pad.xy! @x_place.call(w, c.pad.w), @y_place.call(h, c.pad.h)
        end
      end

      def point_pads x, y, pads
        if mousy? && show?
          pads << self
          return true if @pads.reverse_each.find{ _1.point_pads x - _1.x, y - _1.y, pads }
          pads >> 1
        end
        return false
      end
      
      def autosized?
        true
      end
    end
  end
end