require_relative 'option_group'

module Kredki
  module UI
    class OptionLayer < Layer

      def load_common x, y
        @options.xy! x, y
        action.push_layer self
      end
      
      def unload!
        pad_detach
        update_keyboard_pad nil
      end

      def loaded?
        !!@pad_parent
      end

      def option! ...
        @option_group.option!(...)
      end

      def pad
        @options
      end

      def group
        @option_group
      end

      param_delegate :@options,
      :w, :h, :wh

      #internal api

      def initialize
        super

        @options = new Pad, wh: :fit, color: :gray, layout: :column
        @option_group = @options.new OptionGroup
      end

      def update_mouse_location event = nil
        return if event && event.resolved?
        super
      end

      def mouse_button_down e
      end

      def mouse_button_up e
      end
    end
  end
end