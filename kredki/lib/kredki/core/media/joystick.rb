module Kredki
  class Joystick

    class Button
      model :id, :code
  
      def to_i
        @code
      end
  
      def ==(other)
        Button === other &&
        @code == other.code &&
        @id == other.id
      end
    end

    class Axis
      model :id, :code
  
      def to_i
        @code
      end
    
      def ==(other)
        Axis === other &&
        @code == other.code &&
        @id == other.id
      end
    end

    @@next_name = :joystick_1

    def initialize &block
      @button_map = {}
      @buttoncode_map = {}
      @axis_map = {}
      @axiscode_map = {}
      @device_id = nil
      alter &block
      if @name.nil?
        @name = @@next_name
        @@next_name = @@next_name.next
      end
    end

    def button! id, code
      @button_map[id] = @buttoncode_map[code] = Button.new id, code
    end

    def button param
      case param
      when Button
        param
      else
        @buttoncode_map[param] or @button_map[param] or raise "Unknown button #{param.inspect}"
      end
    end

    def axis! id, code
      @axis_map[id] = @axiscode_map[code] = Axis.new id, code
    end

    def axis param
      case param
      when Axis
        param
      else
        @axiscode_map[param] or @axis_map[param] or raise "Unknown axis #{param.inspect}"
      end
    end

    def down? key
      return nil if !opened?
      is_button_down button(key).to_i
    end

    def value key
      return nil if !opened?
      get_axis_value axis(key).to_i
    end

    def opened?
      !!@device_id
    end

    # :section: LEVEL 2

    def match device_index
      0
    end

    attr_accessor :device_id

    def is_button_down index
      Pastele.joystick_get_button_state(@device_id, index) != 0
    end

    def get_axis_value index
      Pastele.joystick_get_axis_value(@device_id, index)
    end

    private
  end
end