require_relative 'alterable'
require_relative 'has_params'
require_relative 'has_flags'
require_relative 'event/manage/has_event_resolvers'

module Kredki
  class << self
    extend Forwardable

    def init
      if !@arena
        Abi.thorvg_engine_init 2, 4
        Abi.sdl_init ($kredki_joystick || joystick ? 1 : 0)
        @arena = Arena.new
      end
      @arena
    end
 
    def run! action = nil, *a, **na, &block
      if !@arena
        init
        @arena.window! action, *a, **na, &block
      else
        @arena.window.action! action, *a, **na, &block
      end
      @arena.run!
    end

    def_delegators :@arena,
      :terminate!

    attr_accessor :clipboard, :keyboard, :mouse
    attr :arena, :fonts, :colors

    def joysticks=(joysticks)
      @joysticks = joysticks
    end

    def joysticks
      @joysticks ||= []
    end

    def joystick=(default_joystick)
      self.joysticks = [default_joystick, *joysticks]
    end

    def joystick name = nil
      name ? joysticks.find{ _1.name == name } : joysticks.first
    end

    def fonts= fonts
      values = fonts.values
      Font.loaded_fonts.values.reject do |font|
        values.find{ _1 == font || _1 == font.path }
      end.each{ Font.unload _1 }
      @fonts = fonts.map do |id, param|
        case param
        when String
          [id, (Font.load param)]
        when Font
          [id, param]
        end
      end.to_h
    end

    def font param = nil
      case param
      when nil
        @fonts&.each_value&.first || (raise "No fonts loaded")
      when Font
        param
      when :rand
        @fonts&.values.sample || (raise "No fonts loaded")
      when Symbol
        @fonts&.itself[param] || (raise "Unknown font '#{param}'")
      when String
        @fonts&.each_value&.find{|font| font.name == param || font.path == param } || (raise "Unknown font '#{param}'")
      else
        raise "Unknown font '#{param}'"
      end
    end

    def colors= colors
      @colors = colors.map do |id, param|
        [id, case param
        when Color
          param
        when Array
          Color.new *param
        else
          raise "Unknown color '#{param}'"
        end]
      end.to_h
    end

    def color param = nil
      case param
      when nil
        @colors&.each_value&.first || Color.new(255, 255, 255)
      when Color
        param
      when :rand
        Color.new rand(255), rand(255), rand(255)
      when Array
        Color.new *param
      else
        @colors&.itself[param] || (raise "Unknown color '#{param}'")
      end
    end


    #internal api

    def opened_joysticks
      @opened_joysticks ||= {}
    end

  end
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
