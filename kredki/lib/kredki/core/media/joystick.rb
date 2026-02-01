module Kredki
  # Joystick device interface.
  class Joystick
    # Joystick button interface.
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

    # Joystick hat interface.
    class Hat
      # Get hat id.
      def id
        @id
      end

      # Get hat code.
      def code
        @code
      end

      # Set state.
      def state! id, code
        @state_map[id] = @statecode_map[code] = id
      end

      # Get state.
      def state param
        @statecode_map[param] or @state_map[param]
      end
      
      # :section: LEVEL 2

      def initialize id, code
        @id = id
        @code = code
        @state_map = {}
        @statecode_map = {}
      end
      
      def ==(other)
        Hat === other &&
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

    # Get hat codes for input.
    def hats input
      input.flatten.map{ hat(_1).code }.uniq
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
        @buttoncode_map[param] or @button_map[param]
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
        @axiscode_map[param] or @axis_map[param]
      end
    end

    # Set hat.
    def hat! id, code, &block
      @hat_map[id] = @hatcode_map[code] = Hat.new(id, code).alter &block
    end

    # Get hat.
    def hat param
      case param
      when Hat
        param
      else
        @hatcode_map[param] or @hat_map[param]
      end
    end

    # Get whether button is pressed.
    def pressed? key
      return nil if !opened?
      button = button key
      Pastele.joystick_get_button_state(@device_id, button.code) != 0 if button
    end

    # Get axis value.
    def value key
      return nil if !opened?
      axis = axis key
      Pastele.joystick_get_axis_value @device_id, axis.code if axis
    end

    # Get whether joystick is opened.
    def opened?
      !!@device_id
    end

    # :section: LEVEL 2

    @@next_name = :joystick_1

    def initialize
      @button_map = {}
      @buttoncode_map = {}
      @axis_map = {}
      @axiscode_map = {}
      @hat_map = {}
      @hatcode_map = {}
      @device_id = nil
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