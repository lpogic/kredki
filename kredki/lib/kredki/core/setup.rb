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
require_relative 'event/reactions'

module Kredki
  Not = :not

  class << self

    # Kredki root directory.
    def dir
      File.expand_path "../../../..", __FILE__
    end
 
    # Run the application or get the application if it is already running.
    def application opened = nil, *a, **ka, &block
      if !@init
        Pastele.thorvg_engine_init 2, 4
        Pastele.sdl_init joystick ? 1 : 0
        @init = true
      end
      @application = @application_class.new if !@application
      if opened || block
        @application.open opened, *a, **ka, &block
        return @application.run
      end
      @application
    end

    def application= application_class
      @application_class = application_class
    end

    # Milliseconds since SDL was initialized.
    def ms
      Pastele.sdl_get_ticks * 0.000001
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
    def keyboard! keyboard = nil, **ka, &b
      @keyboard = keyboard || Keyboard.new
      @keyboard.set **ka, &b
    end

    # Get keyboard model.
    def keyboard
      @keyboard
    end

    # Set mouse model.
    def mouse! mouse = nil, **ka, &b
      @mouse = mouse || Mouse.new
      @mouse.set **ka, &b
    end

    # Get mouse model.
    def mouse
      @mouse
    end

    # Set joystick model.
    def joystick! key = nil, joystick = nil, **ka, &b
      (@joysticks[key] = joystick || Joystick.new).set **ka, &b
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
      when :random
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
        @colors.each_value.first || Color.new(Color::CHANNEL_MAX, Color::CHANNEL_MAX, Color::CHANNEL_MAX)
      when Color
        param
      when :random
        Color.new rand(Color::CHANNEL_MAX), rand(Color::CHANNEL_MAX), rand(Color::CHANNEL_MAX)
      when Array
        if param.size == 2
          color(param[0]).clarify param[1]
        else
          Color.parse *param
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
      when :random
        @glyphs.values.sample or raise "No glyphs loaded"
      when String
        param
      else
        @glyphs[param] or raise "Unknown glyph #{param.inspect}"
      end
    end

    # Get relative scroll value
    def relative_scroll x, y
      mouse = self.mouse
      keyboard = self.keyboard

      jump = keyboard.alt? ? mouse.scroll_speed_alt : mouse.scroll_speed
      keyboard.shift? ? [y * jump, x * jump] : [x * jump, y * jump]
    end

    # :section: LEVEL 2

    def clear_application
      @application = nil
    end

    attr_accessor :joysticks
    attr_accessor :opened_joysticks
    attr_accessor :fonts
    attr_accessor :colors
    attr_accessor :glyphs

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
  when /darwin/
    self.sdl = "#{dir}/stuff/dylib/libSDL3.0.dylib"
    self.thorvg = "#{dir}/stuff/dylib/libthorvg-1.1.dylib"
    self.pastele = "#{dir}/stuff/dylib/libpastele.dylib"
  end

  self.engine = :sw
  self.config = "#{dir}/stuff/config/config.rb"
  self.text_size = 20
end