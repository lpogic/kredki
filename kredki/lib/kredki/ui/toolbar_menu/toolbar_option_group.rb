require_relative '../option/option_group'

module Kredki
  module UI
    class ToolbarOptionGroup < OptionGroup
      def option! *a, **na, &b
        new ToolbarOption, *a, w: :fit, **na, &b
      end

      def mouse_enter pad
        pad.focus! if parent.keyboard_in? && self[Option...].find{ it.keyboard_in? } != pad
      end
    end
  end
end