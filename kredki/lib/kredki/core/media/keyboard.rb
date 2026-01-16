
module Kredki
  # Keyboard device interface.
  class Keyboard
    include ModifiersDecoder
    
    # Keyboard key interface.
    class Key

      # Get key id.
      def id
        @id
      end

      # Get key code.
      def keycode
        @keycode
      end
  
      # :section: LEVEL 2

      def initialize id, keycode
        @id = id
        @keycode = keycode
      end
  
      def ==(other)
        Key === other &&
        @keycode == other.keycode &&
        @id == other.id
      end
    end

    # Get keycodes for input.
    def keycodes input
      input.flatten.map{ _1.is_a?(String) ? _1.downcase.codepoints : _1 }.flatten.map{ key(_1).keycode }.uniq
    end

    # Set key.
    def key! id, keycode
      @key_map[id] = @keycode_map[keycode] = Key.new id, keycode
    end

    # Get key.
    def key param
      case param
      when Key
        param
      when String
        key param.to_sym
      else
        @keycode_map[param] or @key_map[param]
      end
    end

    # Get whether key is pressed.
    def pressed? param
      Pastele.keyboard_get_key_state(key(param).keycode) != 0
    end

    # :section: LEVEL 2

    def initialize
      @key_map = {}
      @keycode_map = {}
    end

    def inspect
      "#{self.class}:#{object_id}"
    end

    def modifiers
      Pastele.keyboard_get_mod_state
    end

    def key_press_event pastele_event
      KeyboardKeyPressEvent.new self, pastele_event
    end

    def key_release_event pastele_event
      KeyboardKeyReleaseEvent.new self, pastele_event
    end
  end
end