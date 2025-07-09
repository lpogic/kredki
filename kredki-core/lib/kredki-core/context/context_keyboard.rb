require 'forwardable'

module Kredki
  module Context
    class Keyboard
      extend Forwardable
      model :context, :keyboard

      def keycodes input
        input.flatten.map{ _1.is_a?(String) ? _1.downcase.codepoints : _1 }.flatten.map{ @keyboard.key(_1).to_i }.uniq
      end

      aliasing def on_down! ...
        @context.on_key_down!(...)
      end, :on_key_down!

      aliasing def on_up! ...
        @context.on_key_up!(...)
      end, :on_key_up!

      def on_text! ...
        @context.on_text!(...)
      end

      def_delegators :@keyboard,
        :down?,
        :shift?,
        :ctrl?,
        :alt?,
        :num_lock?,
        :caps_lock?,
        :scroll_lock?
    end
  end
end