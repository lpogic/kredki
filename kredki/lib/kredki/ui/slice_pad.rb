require_relative 'pad/sort_pad'

module Kredki
  module UI
    class SlicePad < SortPad

      aliasing def x! x = nil
        set_x_slice((x || 0).to_f) && update_size
      end, :x=

      aliasing def y! y = nil
        set_y_slice((y || 0).to_f) && update_size
      end, :y=

      def xy! x = nil, y = nil
        (set_x_slice((x || 0).to_f) | set_y_slice((y || x || 0).to_f)) && update_size
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
        set_w_slice((w || 1.0).to_f) && update_size
      end, :width!, :w=, :width=

      aliasing def h! h = nil
        set_h_slice((h || 1.0).to_f) && update_size
      end, :height!, :h=, :height=

      aliasing def wh! w = nil, h = nil
        (set_w_slice((w || 1.0).to_f) | set_h_slice((h || w || 1.0).to_f)) && update_size
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

      def initialize ...
        super
        
        @x_slice = @y_slice = 0
        @w_slice = @h_slice = 1.0
      end
      
      def sketch p0
        super

        on_resize! do |e|
          e.resolve
        end

        on! SizeModeEvent do |e|
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
        if parent
          if parent.update_child_xy_on_resize?
            @parent_resize = nil
          else
            @parent_resize = parent.on_resize! do
              update_size
            end
          end
          update_size
        end
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

      def push_pad ...
        super.tap{ update_pads }
      end

      def update_size
        set_xy @x_slice.abs > 1.0 ? @x_slice : parent.w * @x_slice, @y_slice.abs > 1.0 ? @y_slice : parent.h * @y_slice
        set_size(@w_slice > 1.0 ? @w_slice : parent.w * @w_slice, @h_slice > 1.0 ? @h_slice : parent.h * @h_slice) && resize_common
        update_pads
        true
      end

      def update_pads
        w, h = *wh
        @pads.each do |p1|
          p1.wh! w, h unless p1.autosized?
        end
      end

      def max_x
        0
      end

      def max_y
        0
      end
      
      def autosized?
        true
      end
    end
  end
end