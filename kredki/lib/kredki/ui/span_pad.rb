require_relative 'pad/sort_pad'

module Kredki
  module UI
    class SpanPad < SortPad

      #internal api

      def initialize ...
        super
        
        @parent_resize = nil
      end

      def mouse_button_down e
      end

      def mouse_button_up e
      end

      def set_parent parent
        super
        @parent_resize&.detach!
        @parent_resize = parent&.on_resize! do |e|
          p e.target
          update_size if e.target == parent
        end
        update_size
      end

      def update_size
        return if altered? :update_size
        return unless parent
        p parent.wh
        wh! *parent.wh
      end

      def max_x
        @pads.map{ _1.max_x }.max || 0
      end

      def max_y
        @pads.map{ _1.max_y }.max || 0
      end
      
      def autosized?
        true
      end
    end
  end
end