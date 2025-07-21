
module Kredki
  class Keyboard
    model :keys, keywords: true do
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

    def down? key_param
      is_key_down key(key_param).to_i
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

    def num_lock?
      is_num_locked
    end

    def caps_lock?
      is_caps_locked
    end

    def scroll_lock?
      is_scroll_locked
    end

    #internal api

    def inspect
      "#{self.class}:#{object_id}"
    end

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