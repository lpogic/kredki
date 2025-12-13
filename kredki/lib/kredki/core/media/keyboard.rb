
module Kredki
  # Keyboard interface and configuration.
  class Keyboard
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

    # Get whether key is down.
    def down? param
      Pastele.keyboard_get_key_state(key(param).keycode) != 0
    end

    # Get whether left shift is down.
    def left_shift?
      Pastele.keyboard_get_mod_state & 0b0000_0000_0000_0001 != 0
    end

    # Get whether right shift is down.
    def right_shift?
      Pastele.keyboard_get_mod_state & 0b0000_0000_0000_0010 != 0
    end

    # Get whether left alt is down.
    def left_alt?
      Pastele.keyboard_get_mod_state & 0b0000_0001_0000_0000 != 0
    end

    # Get whether right alt is down.
    def right_alt?
      Pastele.keyboard_get_mod_state & 0b0000_0010_0000_0000 != 0
    end

    # Get whether left ctrl is down.
    def left_ctrl?
      Pastele.keyboard_get_mod_state & 0b0000_0010_0100_0000 == 0b0000_0000_0100_0000
    end

    # Get whether right ctrl is down.
    def right_ctrl?
      Pastele.keyboard_get_mod_state & 0b0000_0000_1000_0000 != 0
    end

    # Get whether ctrl is down.
    def ctrl?
      left_ctrl? || right_ctrl?
    end

    # Get whether alt is down.
    def alt?
      left_alt? || right_alt?
    end

    # Get whether shift is down.
    def shift?
      left_shift? || right_shift?
    end

    # Get whether windows key is down.
    def windows?
      Pastele.keyboard_get_mod_state & 0b0000_0100_0000_0000 != 0
    end

    # Get whether num lock is on.
    def num_lock?
      Pastele.keyboard_get_mod_state & 0b0001_0000_0000_0000 != 0
    end

    # Get whether caps lock is on.
    def caps_lock?
      Pastele.keyboard_get_mod_state & 0b0010_0000_0000_0000 != 0
    end

    # Get whether scroll lock is on.
    def scroll_lock?
      Pastele.keyboard_get_mod_state & 0b1000_0000_0000_0000 != 0
    end

    # :section: LEVEL 2

    def initialize &block
      @key_map = {}
      @keycode_map = {}
      alter &block
    end

    def inspect
      "#{self.class}:#{object_id}"
    end
  end
end