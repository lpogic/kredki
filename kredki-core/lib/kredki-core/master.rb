require 'procify'
require 'modeling'
require 'koper'
require 'forwardable'
require_relative 'core-path'
require_relative 'alterable'

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
 
    def run! action = nil, &block
      if !@arena
        init
        action = @arena.window! action
      else
        window = @arena.window
        action = action ? window.action!(action) : window.action
      end
      action.build &block
      @runned = true
      @arena.run!
    end

    def_delegators :@arena,
      :terminate!, :event_director

    attr_accessor :clipboard, :keyboard, :mouse
    attr :runned, :arena, :fonts, :colors

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

    def font param
      case param
      when Font
        param
      when :rand
        @fonts&.values.sample || (raise "No fonts loaded")
      when Symbol
        @fonts&.itself[param] || (raise "Unknown font '#{param}'")
      when String
        @fonts&.values.find{|font| font.name == param || font.path == param } || (raise "Unknown font '#{param}'")
      else
        raise "Unknown font '#{param.class}'"
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

    def color(param)
      case param
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
require_relative 'clipboard'
require_relative 'keyboard'
require_relative 'mouse'
require_relative 'joystick'
require_relative 'shape'
require_relative 'scene'
require_relative 'ellipse'
require_relative 'rectangle'
require_relative 'text'
require_relative 'picture'
require_relative 'animation'
require_relative 'job'
require_relative 'window'
