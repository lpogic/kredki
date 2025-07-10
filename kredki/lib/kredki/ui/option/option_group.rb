require_relative '../pad/service'
require_relative 'option'

module Kredki
  module UI
    class OptionGroup < Service

      def option!(...)
        new(Option, ...)
      end


      #internal api

      def sketch p0
        super
      end

      def key_up
        option = update_select_option :previous
        option&.roi!
      end

      def key_down
        option = update_select_option :next
        option&.roi!
      end

      def mouse_enter pad
        pad.focus! if self[Option...].find{ it.keyboard_in? } != pad
      end

      def update_select_option option
        case option
        when :previous
          options = self[Option...].to_a 
          index = (options.index{ it.keyboard_in? } || 1) - 1
          update_select_option options[index]
        when :next
          options = self[Option...].to_a 
          index = (options.index{ it.keyboard_in? } || -1) + 1
          update_select_option options[index < options.length ? index : 0]
        else
          option&.focus!
          option
        end
      end

    end#OptionGroup
  end#UI
end