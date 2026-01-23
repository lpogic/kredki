# Root gem module.
module Kredki

  class << self
 
    # Start application loop.
    def run scene = nil, *a, **na, &block
      if !@application
        application!.window! scene, *a, **na, &block
      else
        @application.window.scene! scene, *a, **na, &block
      end
      @application.run
    end

    # Milliseconds since SDL was initialized.
    def ms
      Pastele.sdl_get_ticks
    end
    
    # Set clipboard model.
    def clipboard! clipboard = nil
      @clipboard = clipboard || Clipboard.new
    end

    # Get clipboard model.
    def clipboard
      @clipboard
    end

    # Set keyboard model.
    def keyboard! keyboard = nil, **na, &b
      @keyboard = keyboard || Keyboard.new
      @keyboard.alter **na, &b
    end

    # Get keyboard model.
    def keyboard
      @keyboard
    end

    # Set mouse model.
    def mouse! mouse = nil, **na, &b
      @mouse = mouse || Mouse.new
      @mouse.alter **na, &b
    end

    # Get mouse model.
    def mouse
      @mouse
    end

    # Set joystick model.
    def joystick! key = nil, joystick = nil, **na, &b
      (@joysticks[key] = joystick || Joystick.new).alter **na, &b
    end

    # Get joystick model.
    def joystick key = nil
      @joysticks[key] or raise "Joystick #{key.inspect} not registered"
    end

    # Set plugin.
    def plugin! key, &b
      @plugins[key] = b
    end

    # Get plugin.
    def plugin key
      @plugins[key]
    end
    
    # Set font.
    def font! key, path
      @fonts[key] = Font.new path
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
        @fonts.each_value.find{|it| it.name == param || it.path == param } or raise "Unknown font #{param.inspect}"
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

    attr :application
    attr_accessor :joysticks
    attr_accessor :plugins
    attr_accessor :opened_joysticks
    attr_accessor :fonts
    attr_accessor :colors

    def application!
      if !@application
        Pastele.thorvg_engine_init 2, 4
        Pastele.sdl_init ($kredki_joystick || joystick ? 1 : 0)
        @application = Application.new
      end
      @application
    end

  end

  self.colors = {}
  self.fonts = {}
  self.joysticks = {}
  self.opened_joysticks = {}
  self.plugins = {}
end

require_relative 'pastele/pastele'

require_relative 'media/keyboard_modifiers_decoder'

require_relative 'event/event'
require_relative 'event/family/pastele_event'
require_relative 'event/family/focus_enter_event'
require_relative 'event/family/focus_leave_event'
require_relative 'event/family/show_event'
require_relative 'event/family/hide_event'
require_relative 'event/family/drop_event'
require_relative 'event/family/key_event'
require_relative 'event/family/mouse_event'
require_relative 'event/family/tick_event'
require_relative 'event/family/exit_event'
require_relative 'event/family/text_event'
require_relative 'event/family/window_event'
require_relative 'event/family/joystick_event'

require_relative 'application'
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
require_relative 'job/after_job'
require_relative 'job/loop_job'
require_relative 'job/side_job'

require_relative 'event/event_manager'
require_relative 'event/keyboard_event_manager'
require_relative 'event/mouse_event_manager'
require_relative 'event/joystick_event_manager'

require_relative 'window/window_scene'
require_relative 'window/window'
