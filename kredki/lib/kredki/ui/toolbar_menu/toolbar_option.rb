require_relative '../text_pad'
require_relative '../theme'
require_relative '../option/x_option'

module Kredki
  module UI
    class ToolbarOption < XOption

      def option!(...)
        dropdown!.option_group.option!(...)
      end

      param def dropdown! ...
        if !@dropdown
          @dropdown = new ToolbarPrimaryLayer
          @dropdown.pad_detach
        end
        @dropdown.alter(...)
      end

      def has_suboption?
        @dropdown&.[](Option)
      end

      #internal api

      def initialize
        super

        @dropdown = nil
      end

      def sketch p0
        super

        mx! 2

        Event.group on_click!, on_key_down!(:down, :up, :enter, :space) do |e|
          if @dropdown
            @dropdown.load! self unless @dropdown.loaded?
            @dropdown[Option]&.focus! and e.resolve
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
