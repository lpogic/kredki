require_relative 'pad/sort_pad'

module Kredki
  module UI
    class Place < SortPad

      aliasing def l! offset = 0
        set_x_place{ offset } && update_pads
      end, :l=, :left!, :left=

      aliasing def t! offset = 0
        set_y_place{ offset } && update_pads
      end, :t=, :top!, :top=

      aliasing def r! offset = 0
        set_x_place{|w, pw| w - pw - offset } && update_pads
      end, :r=, :right!, :right=

      aliasing def b! offset = 0
        set_y_place{|h, ph| h - ph - offset } && update_pads
      end, :b=, :bottom!, :bottom=

      aliasing def cx! offset = 0
        set_x_place{|w, pw| (w - pw) / 2 + offset } && update_pads
      end, :cx=, :center_x!, :center_x=

      aliasing def cy! offset = 0
        set_y_place{|h, ph| (h - ph) / 2 + offset } && update_pads
      end, :cy=, :center_y!, :center_y=
      
      aliasing def c! xoffset = 0, yoffset = nil
        yoffset ||= xoffset
        (set_x_place{|w, pw| (w - pw) / 2 + xoffset } | set_y_place{|h, ph| (h - ph) / 2 + yoffset }) && update_pads
      end, :center!

      aliasing def c=(xyoffset)
        case xyoffset
        when Array
          c! *xyoffset
        else
          c! xyoffset
        end
      end, :center=

      aliasing def l
        @x_place.call w, 0
      end, :r, :cx, :left, :right, :center_x

      aliasing def t
        @y_place.call w, 0
      end, :b, :cy, :top, :bottom, :center_y

      #internal api

      def initialize ...
        super

        @x_place = @y_place = proc{|a, pa| (a - pa) / 2 }
        @parent_resize = nil
      end

      def sketch p0
        super

        on_resize! do |e|
          if e.target != self
            update_pads
            e.resolve
          end
        end
      end

      def rebound e
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
      
      def set_x_place &place
        @x_place = place
        true
      end

      def set_y_place &place
        @y_place = place
        true
      end

      def min_w
        @pads.map{ _1.min_w }.max || 0
      end

      def min_h
        @pads.map{ _1.min_h }.max || 0
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

      def alter ...
        altering, @altering = @altering, true
        result = super
        @altering = altering
        release unless @altering
        result
      end

      def release
        @after_altering&.each do |k, v|
          send k
        end
        @after_altering = nil
      end

      def after_altering name
        (@after_altering ||= {})[name] = true
      end

      def update_size
        return after_altering :update_size if @altering
        return unless parent
        set_size *parent.wh
        update_pads
      end

      def update_pads
        return after_altering :update_pads if @altering
        w, h = *wh
        @pads.each do |p1|
          p1.xy! @x_place.call(w, p1.w), @y_place.call(h, p1.h)
        end
        true
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