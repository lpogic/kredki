require_relative 'pad/sort_pad'

module Kredki
  module UI
    class PlacePad < SortPad

      aliasing def x! place
        set_place x_place_decode(place), @y_place
      end, :x=

      aliasing def y! place
        set_place @x_place, y_place_decode(place)
      end, :y=

      def xy! xy, y = nil
        set_place x_place_decode(xy), y_place_decode(y || xy)
      end

      def xy= xy
        case xy
        when Array then xy! *xy
        else xy! xy
        end
      end

      def x_place
        @x_place
      end

      def y_place
        @y_place
      end

      def << arg
        case arg
        when Proc
          xy! arg
        else
          super
        end
      end

      #internal api

      def initialize ...
        super

        @x_place = @y_place = POSITION_CENTER
        @parent_resize = nil
      end

      def sketch p0
        super
        
      end

      def resize e
        if e.target != self
          update_pads
        end
      end

      def mouse_button_down e
      end

      def mouse_button_up e
      end

      def set_parent parent
        super
        @parent_resize&.detach!
        @parent_resize = parent&.on_resize! do |e|
          update_size if e.target == parent
        end
        update_size
      end

      def push_pad ...
        super.tap do
          update_size
          report ResizeEvent.new
        end
      end

      def remove_pad pad, transfer
        super.tap do
          update_size unless transfer
        end
      end

      def x_place_decode place
        case place
        when :l, :left, :s, :start then POSITION_START
        when :c, :center then POSITION_CENTER
        when :r, :right, :e, :end then POSITION_END
        when Proc then place
        else raise "Invalid #{place.class}[#{place}] given"
        end
      end

      def y_place_decode place
        case place
        when :t, :top, :s, :start then POSITION_START
        when :c, :center then POSITION_CENTER
        when :b, :bottom, :e, :end then POSITION_END
        when Proc then place
        else raise "Invalid #{place.class}[#{place}] given"
        end
      end

      def set_place x_place, y_place
        (x_place != @x_place || y_place != @y_place) && begin
          @x_place = x_place
          @y_place = y_place
          update_pads
          true
        end
      end

      def update_size
        return if altered? :update_size
        return unless parent
        set_size *parent.wh
        update_pads
      end

      def update_pads
        return if altered? :update_pads
        w, h = *wh
        @pads.each do |p1|
          p1.xy! @x_place.call(p1.w, w), @y_place.call(p1.h, h)
        end
      end

      def after_alter altered
        if altered[:update_size]
          update_size
        elsif altered[:update_pads]
          update_pads
        end
      end

      def max_x
        @pads.map{ _1.max_x - _1.x }.max || 0
      end

      def max_y
        @pads.map{ _1.max_y - _1.y }.max || 0
      end
      
      def autosized?
        true
      end

      def update_child_xy_on_resize?
        true
      end
    end
  end
end