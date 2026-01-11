
module Kredki
  # Keyboard device interface.
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

    # Get whether key is pressed.
    def pressed? param
      Pastele.keyboard_get_key_state(key(param).keycode) != 0
    end

    # Decodes key modifiers.
    module ModifiersDecoder
      # Get whether key modifiers match given criteria.
      def mod_pass? shift: false, alt: false, ctrl: false, windows: false, num_lock: :any, caps_lock: :any, scroll_lock: :any
        mod = modifiers

        case shift
        when :left
          return false if mod & 0b0000_0000_0000_0001 == 0
        when :right
          return false if mod & 0b0000_0000_0000_0010 == 0
        when true
          return false if mod & 0b0000_0000_0000_0011 == 0
        when false
          return false if mod & 0b0000_0000_0000_0011 != 0
        when :any
        else raise_ia shift
        end

        case alt
        when :left
          return false if mod & 0b0000_0001_0000_0000 == 0
        when :right
          return false if mod & 0b0000_0010_0000_0000 == 0
        when true
          return false if mod & 0b0000_0011_0000_0000 == 0
        when false
          return false if mod & 0b0000_0011_0000_0000 != 0
        when :any
        else raise_ia shift
        end

        case ctrl
        when :left
          return false if mod & 0b0000_0000_0100_0000 == 0
        when :right
          return false if mod & 0b0000_0000_1000_0000 == 0
        when true
          return false if mod & 0b0000_0000_1100_0000 == 0
        when false
          return false if mod & 0b0000_0000_1100_0000 != 0
        when :any
        else raise_ia shift
        end

        case windows
        when true
          return false if mod & 0b0000_0100_0000_0000 == 0
        when false
          return false if mod & 0b0000_0100_0000_0000 != 0
        when :any
        else raise_ia shift
        end

        case num_lock
        when true
          return false if mod & 0b0001_0000_0000_0000 == 0
        when false
          return false if mod & 0b0001_0000_0000_0000 != 0
        when :any
        else raise_ia shift
        end

        case caps_lock
        when true
          return false if mod & 0b0010_0000_0000_0000 == 0
        when false
          return false if mod & 0b0010_0000_0000_0000 != 0
        when :any
        else raise_ia shift
        end

        case scroll_lock
        when true
          return false if mod & 0b1000_0000_0000_0000 == 0
        when false
          return false if mod & 0b1000_0000_0000_0000 != 0
        when :any
        else raise_ia shift
        end
      end

      # Get whether left shift is pressed.
      def left_shift?
        modifiers & 0b0000_0000_0000_0001 != 0
      end

      # Get whether right shift is pressed.
      def right_shift?
        modifiers & 0b0000_0000_0000_0010 != 0
      end

      # Get whether left alt is pressed.
      def left_alt?
        modifiers & 0b0000_0001_0000_0000 != 0
      end

      # Get whether right alt is pressed.
      def right_alt?
        modifiers & 0b0000_0010_0000_0000 != 0
      end

      # Get whether left ctrl is pressed (or right alt).
      def left_ctrl?
        modifiers & 0b0000_0000_0100_0000 != 0
      end

      # Get whether right ctrl is pressed.
      def right_ctrl?
        modifiers & 0b0000_0000_1000_0000 != 0
      end

      # Get whether ctrl is pressed.
      def ctrl?
        left_ctrl? || right_ctrl?
      end

      # Get whether alt is pressed.
      def alt?
        left_alt? || right_alt?
      end

      # Get whether shift is pressed.
      def shift?
        left_shift? || right_shift?
      end

      # Get whether windows key is pressed.
      def windows?
        modifiers & 0b0000_0100_0000_0000 != 0
      end

      # Get whether num lock is on.
      def num_lock?
        modifiers & 0b0001_0000_0000_0000 != 0
      end

      # Get whether caps lock is on.
      def caps_lock?
        modifiers & 0b0010_0000_0000_0000 != 0
      end

      # Get whether scroll lock is on.
      def scroll_lock?
        modifiers & 0b1000_0000_0000_0000 != 0
      end
    end

    include ModifiersDecoder

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
  end
end