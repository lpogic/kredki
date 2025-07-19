require_relative '../pad/service'
require_relative 'y_option'

module Kredki
  module UI
    class OptionGroup < Service

      def option!(...)
        new(YOption, ...)
      end
      
      #internal api

      def sketch p0
        super
      end

      def mouse_enter pad
        pad.focus! if self[Option...].find{ it.keyboard_in? } != pad
      end

      def update_select_option option
        case option
        when :previous
          options = self[Option...].to_a 
          index = options.index{ it.keyboard_in? } || 1
          update_select_option options[index - 1] if index > 0
        when :next
          options = self[Option...].to_a 
          index = options.index{ it.keyboard_in? } || -1
          update_select_option options[index + 1] if index < options.length - 1
        else
          option&.focus!
          option
        end
      end

    end#OptionGroup
  end#UI
end