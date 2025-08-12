require_relative 'alterable'
require_relative 'has_params'
require_relative 'has_flags'
require_relative 'event/manage/has_event_resolvers'

module Kredki
  class << self
    extend Forwardable

    def arena!
      if !@arena
        Abi.thorvg_engine_init 2, 4
        Abi.sdl_init ($kredki_joystick || joystick ? 1 : 0)
        @arena = Arena.new
      end
      @arena
    end
 
    def run! action = nil, *a, **na, &block
      if !@arena
        arena.window! action, *a, **na, &block
      else
        @arena.window.action! action, *a, **na, &block
      end
      @arena.run!
    end

    def_delegators :@arena,
      :terminate!

    attr_accessor :clipboard, :keyboard, :mouse, :joysticks
    attr :arena

    def clipboard! clipboard = nil
      @clipboard = clipboard || Clipboard.new
    end

    def keyboard! keyboard = nil, **na, &b
      @keyboard = keyboard || Keyboard.new
      @keyboard.alter **na, &b
    end

    def mouse! mouse = nil, **na, &b
      @mouse = mouse || Mouse.new
      @mouse.alter **na, &b
    end

    def joystick! id = nil, joystick = nil, **na, &b
      (@joysticks[id] = joystick || Joystick.new).alter **na, &b
    end

    def joystick id = nil
      @joysticks[id] or raise "Joystick #{id.inspect} not registered"
    end

    attr_accessor :font_map
    
    def font! id, path
      @font_map[id] = Font.new path
    end

    def font param = nil
      case param
      when nil
        @font_map.each_value&.first or raise "No fonts loaded"
      when Font
        param
      when :rand
        @font_map.values.sample or raise "No fonts loaded"
      when String
        @font_map.each_value.find{ it.name == param || it.path == param } or raise "Unknown font #{param.inspect}"
      else
        @font_map.itself[param] or raise "Unknown font #{param.inspect}"
      end
    end

    attr_accessor :color_map

    def color! id, r, g, b, a
      @color_map[id] = Color.new r, g, b, a
    end

    def color param = nil
      case param
      when nil
        @color_map.each_value.first || Color.new(255, 255, 255)
      when Color
        param
      when :rand
        Color.new rand(255), rand(255), rand(255)
      when Array
        Color.new *param
      else
        @color_map[param] or raise "Unknown color #{param}"
      end
    end

    #internal api

    attr_accessor :opened_joysticks

  end
  self.color_map = {}
  self.font_map = {}
  self.joysticks = {}
  self.opened_joysticks = {}
end

require_relative 'abi/abi'

require_relative 'arena'
require_relative 'media/clipboard'
require_relative 'media/keyboard'
require_relative 'media/mouse'
require_relative 'media/joystick'

require_relative 'color'
require_relative 'font'

require_relative 'paint/paint'
require_relative 'paint/shape'
require_relative 'paint/scene'
require_relative 'paint/area'
require_relative 'paint/shape_area'
require_relative 'paint/block_shape_area'
require_relative 'paint/ellipse'
require_relative 'paint/rectangle'
require_relative 'paint/text'
require_relative 'paint/picture'
require_relative 'paint/animation'
require_relative 'job'

require_relative 'action/action'
require_relative 'window'
