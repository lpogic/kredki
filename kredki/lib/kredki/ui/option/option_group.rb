require_relative '../pad/service'

module Kredki
  module UI
    class OptionGroup < Service

      model do
        @options = []
      end

      attr :options

      #internal api

      def append pad
        @options << pad
      end

      def remove pad
        @options.delete pad
      end

      def key e
        case e.symbol
        when :up
          option = update_select_option :previous
          option&.roi!
          e.resolve
        when :down
          option = update_select_option :next
          option&.roi!
          e.resolve
        end
      end

      def mouse_enter pad
        pad.focus! if @options.find{ it.keyboard_in? } != pad
      end

      def update_select_option option
        case option
        when :previous
          index = (@options.index{ it.keyboard_in? } || 1) - 1
          update_select_option @options[index]
        when :next
          index = (@options.index{ it.keyboard_in? } || -1) + 1
          update_select_option @options[index < @options.length ? index : 0]
        else
          option&.focus!
          option
        end
      end

    end#OptionGroup
  end#UI
end