module Kredki
  class Keyboard
    model :keys do
      @inverted_keys = @keys.invert
    end

    def key param
      case param
      when Key
        param
      when Symbol
        Key.new @keys[param] || (raise "Unknown mouse button symbol :#{param}"), param
      when Integer
        Key.new param, @inverted_keys[param]
      end
    end
    
    class Key
  
      model :keycode, :symbol
  
      def to_i
        @keycode
      end
  
      def to_sym
        @symbol
      end
  
      def ==(other)
        Key === other &&
        scancode == other.scancode &&
        symbol == other.symbol
      end
    end

    def down? key
      is_key_down Key[key].to_i
    end

    def shift?
      is_shift_down
    end

    def ctrl?
      is_ctrl_down
    end

    def alt?
      is_alt_down
    end

    def num?
      is_num_locked
    end

    def caps?
      is_caps_locked
    end

    def scroll?
      is_scroll_locked
    end

    #internal api

    private

    def is_key_down keycode
      Abi.keyboard_get_key_state(keycode) != 0
    end

    def is_ctrl_down
      Abi.keyboard_get_ctrl_state != 0
    end

    def is_alt_down
      Abi.keyboard_get_alt_state != 0
    end

    def is_shift_down
      Abi.keyboard_get_shift_state != 0
    end

    def is_scroll_locked
      Abi.keyboard_get_scroll_state != 0
    end

    def is_caps_locked
      Abi.keyboard_get_caps_state != 0
    end

    def is_num_locked
      Abi.keyboard_get_num_state != 0
    end
  end
end