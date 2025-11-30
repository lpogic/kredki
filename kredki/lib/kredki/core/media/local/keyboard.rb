module Kredki
  module LocalMedia
    class Keyboard
      extend HasFeatures
      extend HasEventResolvers

      model :host, :keyboard

      def keycodes input
        input.flatten.map{ _1.is_a?(String) ? _1.downcase.codepoints : _1 }.flatten.map{ @keyboard.key(_1).to_i }.uniq
      end

      event_resolver def on_down! ...
        @host.on_key_down!(...)
      end

      event_resolver def on_key_down! ...
        @host.on_key_down!(...)
      end

      event_resolver def on_up! ...
        @host.on_key_up!(...)
      end

      event_resolver def on_key_up! ...
        @host.on_key_up!(...)
      end

      event_resolver def on_text! ...
        @host.on_text!(...)
      end

      def down? key
        @host&.layer&.check_key_down key
      end

      def_delegators :@keyboard,
        :shift?,
        :ctrl?,
        :alt?,
        :num_lock?,
        :caps_lock?,
        :scroll_lock?
    end
  end
end