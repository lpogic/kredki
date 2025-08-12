require_relative '../text_pad'
require_relative '../theme'
require_relative '../item/y_item'

module Kredki
  module UI
    class ContextItem < YItem

      def item!(...)
        dropdown!.item_group.item!(...)
      end

      param def dropdown! ...
        if !@dropdown
          @dropdown = new ContextSecondaryLayer
          @end_icon.scenic!
        end
        @dropdown.alter(...)
      end

      def has_subitem?
        @dropdown&.[](Item)
      end

      #internal api

      def initialize
        super

        @dropdown = nil
        @begin_icon = new Pad, at: 0, mousy: false, keyboardy: false, color: 0, h: 100r do
          w! proc{ get_h }
          stroke! color: :text, size: 3, cap: :round, join: :miter
          scenic! false
        end
        @end_icon = new Pad, mousy: false, keyboardy: false, color: 0, x: :end, h: 100r do
          w! proc{ get_h }
          stroke! color: :text, size: 3, cap: :round, join: :miter
          area! do |w, h|
            xy! w * 0.5, h * 0.3
            line! w * 0.7, h * 0.5
            line! w * 0.5, h * 0.7
          end
          scenic! false
        end
      end

      def sketch p0
        super

        on_key_down! :right do |e|
          if @dropdown
            @dropdown.load! self unless @dropdown.loaded?
            @dropdown[Item]&.focus! and e.resolve
          end
        end
      end

      def mouse_enter e
        super
        @dropdown.update_keyboard_pad nil if @dropdown&.loaded?
      end

      def min_w
        @text.fit_w + get_h * 2
      end
    end
  end
end
