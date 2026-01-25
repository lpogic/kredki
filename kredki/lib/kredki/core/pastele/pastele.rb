require 'fiddle/import'

module Kredki
  module Pastele
    extend Fiddle::Importer
    if Setup.unit_test_mode
      class << self
        alias_method :o_extern, :extern

        def extern function
          function = o_extern(function).name
          class_eval <<~RUBY
            class << self
              alias_method :o_#{function}, :#{function}
              def #{function} *a
                calls << [:#{function}, *a]
                o_#{function} *a
              end
            end
          RUBY

        end

        attr_accessor :calls
      end

      self.calls = []
    end

    current_lib = nil
    begin
      dlload (current_lib = Setup.sdl || raise("SDL shared library setup is missing"))
      dlload (current_lib = Setup.thorvg || raise("ThorVG shared library setup is missing"))
      dlload (current_lib = Setup.pastele || raise("Pastele shared library setup is missing"))

    rescue LoadError
      raise LoadError, "Could not load #{current_lib}"
    rescue Fiddle::DLError
      raise Fiddle::DLError, current_lib
    end

    UserEvent = struct [
      'uint32_t type',
      'uint32_t reserved',
      'uint64_t timestamp',
      'uint32_t window_id',
    ]

    KeyboardEvent = struct [
      'uint32_t type',
      'uint32_t reserved',
      'uint64_t timestamp',
      'uint32_t window_id',
      'uint32_t keyboard_id',
      'int scancode',
      'int sym',
      'uint16_t mod',
      'uint16_t raw',
      # 'bool down',
      # 'bool repeat',
    ]

    MouseMotionEvent = struct [
      'uint32_t type',
      'uint32_t reserved',
      'uint64_t timestamp',
      'uint32_t window_id',
      'uint32_t which',
      'uint32_t state',
      'float x',
      'float y',
      'float xrel',
      'float yrel',
    ]

    MouseButtonEvent = struct [
      'uint32_t type',
      'uint32_t reserved',
      'uint64_t timestamp',
      'uint32_t window_id',
      'uint32_t which',
      'uint8_t button',
      'uint8_t down', # bool
      'uint8_t clicks',
      'uint8_t padding1', #unused
      'float x',
      'float y',
    ]

    MouseWheelEvent = struct [
      'uint32_t type',
      'uint32_t reserved',
      'uint64_t timestamp',
      'uint32_t window_id',
      'uint32_t which',
      'float x',
      'float y',
      'uint32_t direction',
      'float mouse_x',
      'float mouse_y',
    ]

    WindowEvent = struct [
      'uint32_t type',
      'uint32_t reserved',
      'uint64_t timestamp',
      'uint32_t window_id',
      'int32_t data1',
      'int32_t data2',
    ]

    DisplayEvent = struct [
      'uint32_t type',
      'uint32_t reserved',
      'uint64_t timestamp',
      'uint32_t display',
      'int32_t data1',
      'int32_t data2',
    ]

    TextInputEvent = struct [
      'uint32_t type',
      'uint32_t reserved',
      'uint64_t timestamp',
      'uint32_t window_id',
      'char* text'
    ]

    DropEvent = struct [
      'uint32_t type',
      'uint32_t reserved',
      'uint64_t timestamp',
      'uint32_t window_id',
      'float x',
      'float y',
      'char* source',
      'char* data',
    ]

    QuitEvent = struct [
      'uint32_t type',
      'uint32_t reserved',
      'uint64_t timestamp',
    ]

    JoyDeviceEvent = struct [
      'uint32_t type',
      'uint32_t reserved',
      'uint64_t timestamp',
      'uint32_t which',
    ]
    
    JoyButtonEvent = struct [
      'uint32_t type',
      'uint32_t reserved',
      'uint64_t timestamp',
      'uint32_t which',
      'uint8_t button',
      'uint8_t down' # bool
    ]

    JoyAxisEvent = struct [
      'uint32_t type',
      'uint32_t reserved',
      'uint64_t timestamp',
      'uint32_t which',
      'uint8_t axis',
      'uint8_t padding1', #unused
      'uint8_t padding2', #unused
      'uint8_t padding3', #unused
      'int16_t value'
    ]

    Bounds = struct [
      'float x',
      'float y',
      'float w',
      'float h',
    ]

    Point = struct [
      'float x',
      'float y'
    ]

    IntPoint = struct [
      'int x',
      'int y',
    ]
  end
end


require_relative 'pastele-extern'