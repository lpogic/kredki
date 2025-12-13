require_relative '../text_pad'
require_relative '../item/x_item'

module Kredki
  module UI
    class ToolbarItem < XItem

      def item!(...)
        dropdown!.item_group.item!(...)
      end

      feature def dropdown! ...
        if !@dropdown
          @dropdown = new ToolbarPrimaryLayer
          @dropdown.pad_detach
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
      end

      def sketch
        super

        margin_x! 2
      end

      def sketch_behavior
        super

        on_key_down! :down, :up, :enter, :space do |e|
          if @dropdown
            @dropdown.load! self unless @dropdown.loaded?
            @dropdown[Item]&.keyboard_request and e.resolve
          end
        end

        on_click! do |e|
          if @dropdown
            @dropdown.load! self unless @dropdown.loaded?
          end
        end
      end

      def mouse_enter e
        super
        @dropdown.update_keyboard_pad nil if @dropdown&.loaded?
      end

      def min_w
        @text.fit_w
      end
    end
  end
end
