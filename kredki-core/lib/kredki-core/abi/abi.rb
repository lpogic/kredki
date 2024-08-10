require 'fiddle/import'

module Kredki
  module Abi
    extend Fiddle::Importer
    
    current_lib = nil
    begin
      dlload (current_lib = $kredki_libsharp || raise("$kredki_libsharp not configured"))
      dlload (current_lib = $kredki_libwebp || raise("$kredki_libwebp not configured"))
      dlload (current_lib = $kredki_zlib || raise("$kredki_zlib not configured"))
      dlload (current_lib = $kredki_libpng || raise("$kredki_libpng not configured"))
      dlload (current_lib = $kredki_sdl || raise("$kredki_sdl not configured"))
      dlload (current_lib = $kredki_thorvg || raise("$kredki_thorvg not configured"))
      dlload (current_lib = $kredki_pastele || raise("$kredki_pastele not configured"))
    rescue LoadError
      raise LoadError, "Could not find '#{current_lib}' shared library"
    rescue Fiddle::DLError
      raise Fiddle::DLError, current_lib
    end

    KeyboardEvent = struct [
      'uint32_t type',
      'uint32_t timestamp',
      'uint32_t window_id',
      'uint8_t state',
      'uint8_t repeat',
      'uint8_t padding2', #unused
      'uint8_t padding3', #unused
      'int scancode',
      'int sym',
      'uint16_t mod',
    ]

    MouseMotionEvent = struct [
      'uint32_t type',
      'uint32_t timestamp',
      'uint32_t window_id',
      'uint32_t which',
      'uint32_t state',
      'int32_t x',
      'int32_t y',
      'int32_t xrel',
      'int32_t yrel',
    ]

    MouseButtonEvent = struct [
      'uint32_t type',
      'uint32_t timestamp',
      'uint32_t window_id',
      'uint32_t which',
      'uint8_t button',
      'uint8_t state',
      'uint8_t clicks',
      'uint8_t padding1', #unused
      'int32_t x',
      'int32_t y',
    ]

    MouseWheelEvent = struct [
      'uint32_t type',
      'uint32_t timestamp',
      'uint32_t window_id',
      'uint32_t which',
      'int32_t x',
      'int32_t y',
      'uint32_t direction',
      'float precise_x',
      'float precise_y',
      'int32_t mouse_x',
      'int32_t mouse_y',
    ]

    WindowEvent = struct [
      'uint32_t type',
      'uint32_t timestamp',
      'uint32_t window_id',
      'uint8_t event',
      'uint8_t padding1', #unused
      'uint8_t padding2', #unused
      'uint8_t padding3', #unused
      'int32_t data1',
      'int32_t data2',
    ]

    DisplayEvent = struct [
      'uint32_t type',
      'uint32_t timestamp',
      'uint32_t display',
      'uint8_t event',
      'uint8_t padding1', #unused
      'uint8_t padding2', #unused
      'uint8_t padding3', #unused
      'int32_t data1',
    ]

    TextInputEvent = struct [
      'uint32_t type',
      'uint32_t timestamp',
      'uint32_t window_id',
      # char text[] acquired by pointer arithmetic
    ]

    DropEvent = struct [
      'uint32_t type',
      'uint32_t timestamp',
      'char* file',
      'uint32_t window_id'
    ]

    QuitEvent = struct [
      'uint32_t type',
      'uint32_t timestamp',
    ]

    JoyDeviceEvent = struct [
      'uint32_t type',
      'uint32_t timestamp',
      'uint32_t which',
    ]
    
    JoyButtonEvent = struct [
      'uint32_t type',
      'uint32_t timestamp',
      'uint32_t which',
      'uint8_t button',
      'uint8_t state'
    ]

    JoyAxisEvent = struct [
      'uint32_t type',
      'uint32_t timestamp',
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


require_relative 'tvg.gen'