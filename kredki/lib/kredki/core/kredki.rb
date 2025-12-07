require_relative 'has_features'
require_relative 'event/manage/has_event_resolvers'

# Root gem module.
module Kredki
  class << self
 
    # Start application loop.
    def run! action = nil, *a, **na, &block
      if !@arena
        arena!.window! action, *a, **na, &block
      else
        @arena.window.action! action, *a, **na, &block
      end
      @arena.run!
    end

    # Break application loop.
    def terminate! ...
      @arena.terminate!(...)
    end

    attr_accessor :run_ms

    # Milliseconds since application loop was started.
    def ms
      Pastele.sdl_get_ticks - run_ms
    end
    
    # Set clipboard model.
    def clipboard! clipboard = nil
      @clipboard = clipboard || Clipboard.new
    end

    # Set keyboard model.
    def keyboard! keyboard = nil, **na, &b
      @keyboard = keyboard || Keyboard.new
      @keyboard.alter **na, &b
    end

    # Set mouse model.
    def mouse! mouse = nil, **na, &b
      @mouse = mouse || Mouse.new
      @mouse.alter **na, &b
    end

    # Set joystick model.
    def joystick! id = nil, joystick = nil, **na, &b
      (@joysticks[id] = joystick || Joystick.new).alter **na, &b
    end

    # Get joystick model.
    def joystick id = nil
      @joysticks[id] or raise "Joystick #{id.inspect} not registered"
    end

    # Set plugin.
    def plugin! id, &b
      @plugins[id] = b
    end

    # Get plugin.
    def plugin id
      @plugins[id]
    end
    
    # Set font.
    def font! id, path
      @fonts[id] = Font.new path
    end

    # Get font.
    def font param = nil
      case param
      when nil
        @fonts.each_value&.first or raise "No fonts loaded"
      when Font
        param
      when :rand
        @fonts.values.sample or raise "No fonts loaded"
      when String
        @fonts.each_value.find{ it.name == param || it.path == param } or raise "Unknown font #{param.inspect}"
      else
        @fonts.itself[param] or raise "Unknown font #{param.inspect}"
      end
    end

    # Set color.
    def color! id, *a
      @colors[id] = Color.parse *a
    end

    # Get color.
    def color param = nil
      case param
      when nil
        @colors.each_value.first || Color.new(255, 255, 255)
      when Color
        param
      when :rand
        Color.new rand(255), rand(255), rand(255)
      when Array
        if param.size == 2
          color(param[0]).clarify param[1]
        else
          Color.new *param
        end
      else
        @colors[param] or raise "Unknown color #{param}"
      end
    end

    # :section: LEVEL 2

    attr_accessor :clipboard, :keyboard, :mouse, :joysticks, :plugins
    attr :arena
    attr_accessor :opened_joysticks
    attr_accessor :fonts
    attr_accessor :colors

    def arena!
      if !@arena
        Pastele.thorvg_engine_init 2, 4
        Pastele.sdl_init ($kredki_joystick || joystick ? 1 : 0)
        @arena = Arena.new
      end
      @arena
    end

  end

  self.colors = {}
  self.fonts = {}
  self.joysticks = {}
  self.opened_joysticks = {}
  self.plugins = {}
end

require_relative 'pastele/pastele'

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
require_relative 'job/job'
require_relative 'job/stop_job'
require_relative 'job/root_job'
require_relative 'job/after_job'
require_relative 'job/loop_job'
require_relative 'job/side_job'

require_relative 'action/action'
require_relative 'window'
