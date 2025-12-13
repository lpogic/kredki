require_relative '../text_pad'
require_relative '../item/y_item'

module Kredki
  module UI
    class ContextItem < YItem

      def item!(...)
        dropdown!.item_group.item!(...)
      end

      feature def dropdown! ...
        if !@dropdown
          @dropdown = new ContextSecondaryLayer
          @end_icon.scenic!
        end
        @dropdown.alter(...)
      end

      def has_subitem?
        @dropdown&.[](Item)
      end

      # :section: LEVEL 2

      def initialize
        super

        @dropdown = nil
        @begin_icon = new RectanglePad, at: 0, mousy: false, keyboardy: false, fill: 0, h: 1r do
          w! proc{ get_h }
          out! fill: :text, w: 3, cap: :round, join: :miter
          scenic! false
        end
        @end_icon = new RectanglePad, mousy: false, keyboardy: false, fill: 0, x: :e, h: 1r do
          w! proc{ get_h }
          out! fill: :text, w: 3, cap: :round, join: :miter
          area! do |w, h|
            xy! w * 0.5, h * 0.35
            line! w * 0.65, h * 0.5
            line! w * 0.5, h * 0.65
          end
          scenic! false
        end
      end

      def sketch
        super

        on_key_down! :right do |e|
          if @dropdown
            @dropdown.load! self unless @dropdown.loaded?
            @dropdown[Item]&.keyboard_request and e.resolve
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
