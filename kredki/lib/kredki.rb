def ext(path) = File.expand_path "../../ext/#{path}", __FILE__

if RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/
  $kredki_libsharp = ext "dll/libsharpyuv.dll"
  $kredki_libwebp = ext "dll/libwebp.dll"
  $kredki_zlib = ext "dll/zlib1.dll"
  $kredki_libpng = ext "dll/libpng16.dll"
  $kredki_sdl = ext "dll/SDL2.dll"
  $kredki_thorvg = ext "dll/thorvg-0.dll"
  $kredki_pastele = ext "dll/pastele.dll"
end

require 'kredki-core'

Kredki.colors = {
  red: Kredki::Color.new(222, 0, 0, 255),
  green: Kredki::Color.new(0, 222, 0, 255),
  blue: Kredki::Color.new(0, 0, 222, 255),
  light_gray: Kredki::Color.new(211, 211, 211, 255),
  gray: Kredki::Color.new(111, 111, 111, 255),
  white: Kredki::Color.new(255, 255, 255, 255),
  black: Kredki::Color.new(0, 0, 0, 255),
  yellow: Kredki::Color.new(222, 222, 0, 255),
  transparent: Kredki::Color.new(0, 0, 0, 0),
}

Kredki.clipboard = Kredki::Clipboard.new

Kredki.keyboard = Kredki::Keyboard.new keys: {
  escape: 27,
  f1: 1073741882, f2: 1073741883, f3: 1073741884, f4: 1073741885,
  f5: 1073741886, f6: 1073741887, f7: 1073741888, f8: 1073741889,
  f9: 1073741890, f10: 1073741891, f11: 1073741892, f12: 1073741893,
  backspace: 8,
  space: 32,
  enter: 13,
  left: 1073741904, right: 1073741903, up: 1073741906, down: 1073741905,
  one: 49, two: 50, three: 51, four: 52, five: 53, six: 54, seven: 55, eight: 56, nine: 57, zero: 48,
  minus: 45,
  equals: 61,
  backquote: 96,
  tab: 9,
  caps_lock: 1073741881,
  left_shift: 1073742049, left_ctrl: 1073742048, left_alt: 1073742048,
  right_alt: 1073742054, right_ctrl: 1073742052, right_shift: 1073742053,
  insert: 1073741897, home: 1073741898, page_up: 1073741899,
  delete: 127, end: 1073741901, page_down: 1073741902,
  print_screen: 1073741894, pause: 1073741895, scroll_lock: 1073741896,
  num_lock: 1073741907,
  keypad_slash: 1073741908, keypad_star: 1073741909, keypad_minus: 1073741910,
  keypad_plus: 1073741911,
  keypad_enter: 1073741912,
  keypad_delete: 1073741923,
  keypad_insert: 1073741922,
  keypad_one: 1073741913, keypad_two: 1073741914, keypad_three: 1073741915,
  keypad_four: 1073741916, keypad_five: 1073741917, keypad_six: 1073741918,
  keypad_seven: 1073741919, keypad_eight: 1073741920, keypad_nine: 1073741921,
  q: 113, w: 119, e: 101, r: 114, t: 116, y: 121, u: 117, i: 105, o: 111, p: 112,
  a: 97, s: 115, d: 100, f: 102, g: 103, h: 104, j: 106, k: 107, l: 108,
  z: 122, x: 120, c: 99, v: 118, b: 98, n: 110, m: 109,
  open_bracket: 91, close_bracket: 93,
  semicolon: 59, quote: 39, backslash: 92,
  comma: 44, dot: 46, slash: 47,
  windows: 1073742051,
  context: 1073741925,
  play: 1073742085,
  mute: 1073741951,
  volume_down: 1073741953,
  volume_up: 1073741952,
  house: 1073742093,
  mail: 1073742089,
  calulator: 1073742108,
}

Kredki.mouse = Kredki::Mouse.new buttons: {
  primary: 1,
  secondary: 3,

  left: 1,
  center: 2,
  right: 3
}

Kredki.joystick = Kredki::Joystick.new buttons: {
  _1: 0,
  _2: 1,
  _3: 2,
  _4: 3,
  _5: 4,
  _6: 5,
  _7: 6,
  _8: 7,
}, axes: {
  x: 0,
  y: 1,
  z: 2,
}

Kredki.fonts = {
  arial: ext("font/Arial.ttf"),
  lato: ext("font/Lato-Regular.ttf"),
  dejavu: ext("font/DejaVuSans.ttf"),
}

class TerminateOnEsc
  def self.plug_into action
    action.on_key! :escape do |event|
      action.window.terminate!
    end
  end
end

class CloseOnEsc
  def self.plug_into action
    action.on_key! :escape do |event|
      action.window.destroy!
    end
  end
end

# A = Kredki.init
# A.window! action: Kredki::Action.new

require_relative 'kredki/ui_action'

module Kredki
  class Window
    aliasing def action! action = nil, &block
      action ||= UiAction.new
      set_action action, &block
    end, :action=
  end
end

A = Kredki.init
A.window! action: Kredki::UiAction.new

class << self 
  def respond_to? name
    super || A.window.respond_to?(name)
  end

  def method_missing name, *a, **na, &b
    A.window.respond_to?(name) ? A.window.send(name, *a, **na, &b) : super
  end
end

if $0 != 'irb'
  at_exit do
    Kredki.run if !Kredki.runned
  end
end