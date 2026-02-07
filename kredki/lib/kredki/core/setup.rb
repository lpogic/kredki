require_relative 'kernel-path'
require_relative 'media/clipboard'
require_relative 'media/keyboard_modifiers_decoder'
require_relative 'media/keyboard'
require_relative 'media/mouse'
require_relative 'media/joystick'
require_relative 'color'
require_relative 'font'
require_relative 'linear_gradient'
require_relative 'radial_gradient'

module Kredki
  class << self

    # Kredki root directory.
    def dir
      File.expand_path "../../../..", __FILE__
    end
 
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

    # Get fill.
    def fill param
      case param
      when LinearGradient, RadialGradient
        param
      else
        color param
      end
    end
        

    # Set glyph.
    def glyph! key, path
      @glyphs[key] = path
    end

    # Get glyph.
    def glyph param = nil
      case param
      when :rand
        @glyphs.values.sample or raise "No glyphs loaded"
      when String
        param
      else
        @glyphs[param] or raise "Unknown glyph #{param.inspect}"
      end
    end

    # :section: LEVEL 2

    attr :application
    attr_accessor :joysticks
    attr_accessor :opened_joysticks
    attr_accessor :fonts
    attr_accessor :colors
    attr_accessor :glyphs

    def application!
      if !@application
        Pastele.thorvg_engine_init 2, 4
        Pastele.sdl_init joystick ? 1 : 0
        @application = Application.new
      end
      @application
    end

    attr_accessor :sdl
    attr_accessor :thorvg
    attr_accessor :pastele

    attr_accessor :engine
    attr_accessor :config
    attr_accessor :unit_test_mode

    attr_accessor :text_size
  end

  self.colors = {}
  self.fonts = {}
  self.glyphs = {}
  self.joysticks = {}
  self.opened_joysticks = {}

  case RUBY_PLATFORM
  when /cygwin|mswin|mingw|bccwin|wince|emx/
    self.sdl = "#{dir}/stuff/dll/SDL3.dll"
    self.thorvg = "#{dir}/stuff/dll/thorvg-1.dll"
    self.pastele = "#{dir}/stuff/dll/pastele.dll"
  when /linux/
    self.sdl = "#{dir}/stuff/so/libSDL3.so"
    self.thorvg = "#{dir}/stuff/so/libthorvg-1.so"
    self.pastele = "#{dir}/stuff/so/libpastele.so"
  end

  self.engine = :sw
  self.config = "#{dir}/stuff/config/config.rb"
  self.text_size = 16
end