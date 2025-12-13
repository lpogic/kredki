module Kredki
  # Joystick interface and configuration.
  class Joystick
    # Joystick button interface
    class Button

      # Get button id.
      def id
        @id
      end

      # Get button code.
      def code
        @code
      end

      # :section: LEVEL 2

      def initialize id, code
        @id = id
        @code = code
      end

      def ==(other)
        Button === other &&
        @code == other.code &&
        @id == other.id
      end
    end

    # Joystick axis interface.
    class Axis
      # Get axis id.
      def id
        @id
      end

      # Get axis code.
      def code
        @code
      end
      
      # :section: LEVEL 2

      def initialize id, code
        @id = id
        @code = code
      end
      
      def ==(other)
        Axis === other &&
        @code == other.code &&
        @id == other.id
      end
    end

    # Get button codes for input.
    def buttons input
      input.flatten.map{ button(_1).code }.uniq
    end

    # Get axis codes for input.
    def axes input
      input.flatten.map{ axis(_1).code }.uniq
    end

    # Set button.
    def button! id, code
      @button_map[id] = @buttoncode_map[code] = Button.new id, code
    end

    # Get button.
    def button param
      case param
      when Button
        param
      else
        @buttoncode_map[param] or @button_map[param] or raise "Unknown button #{param.inspect}"
      end
    end

    # Set axis.
    def axis! id, code
      @axis_map[id] = @axiscode_map[code] = Axis.new id, code
    end

    # Get axis.
    def axis param
      case param
      when Axis
        param
      else
        @axiscode_map[param] or @axis_map[param] or raise "Unknown axis #{param.inspect}"
      end
    end

    # Get whether button is down.
    def down? key
      return nil if !opened?
      Pastele.joystick_get_button_state(@device_id, button(key).code) != 0
    end

    # Get axis value.
    def value key
      return nil if !opened?
      Pastele.joystick_get_axis_value(@device_id, axis(key).code)
    end

    # Get whether joystick is opened.
    def opened?
      !!@device_id
    end

    # :section: LEVEL 2

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

    def match device_index
      0
    end

    attr_accessor :device_id

  end
end