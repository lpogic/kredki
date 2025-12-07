require 'fiddle/import'

module Kredki
  module Pastele
    extend Fiddle::Importer
    
    current_lib = nil
    begin
      dlload (current_lib = $kredki_sdl || raise("$kredki_sdl not configured"))
      dlload (current_lib = $kredki_thorvg || raise("$kredki_thorvg not configured"))
      dlload (current_lib = $kredki_pastele || raise("$kredki_pastele not configured"))
    rescue LoadError
      raise LoadError, "Could not find '#{current_lib}' shared library"
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
      # 'char* file',
      # 'uint32_t window_id'
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