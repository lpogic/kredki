
module Kredki
  class Keyboard

    class Key

      model :id, :keycode
  
      def to_i
        @keycode
      end
  
      def to_sym
        @id
      end
  
      def ==(other)
        Key === other &&
        @keycode == other.keycode &&
        @id == other.id
      end
    end

    def initialize &block
      @key_map = {}
      @keycode_map = {}
      alter &block
    end

    def key! id, keycode
      @key_map[id] = @keycode_map[keycode] = Key.new id, keycode
    end

    def key param
      case param
      when Key
        param
      else
        @keycode_map[param] or @key_map[param]
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