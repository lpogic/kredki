require 'forwardable'

module Kredki
  class Action
    class Keyboard
      extend Forwardable
      model :action, :keyboard

      def keycodes *input
        input.flatten.map{ _1.is_a?(String) ? _1.downcase.codepoints : _1 }.flatten.map{ @keyboard.key(_1).to_i }.uniq
      end

      def on_down! ...
        @action.on_key_down!(...)
      end

      def on_up! ...
        @action.on_key_up!(...)
      end

      def on_text! ...
        @action.on_text!(...)
      end

      def_delegators :@keyboard,
        :down?,
        :shift?,
        :ctrl?,
        :alt?,
        :num?,
        :caps?,
        :scroll?
    end
  end
end