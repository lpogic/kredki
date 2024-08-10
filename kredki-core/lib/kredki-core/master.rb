require 'procify'
require 'modeling'
require 'koper'
require 'forwardable'

class Class
  def enum *symbols, **key_symbols
    @symbols = symbols.each_with_index.to_h + key_symbols
    
    define_method :initialize do |int, symbol|
      @int = int
      @symbol = symbol
    end

    define_singleton_method :[] do |value|
      case value
      when self
        value
      when Integer
        self.new value, @symbols.key(value)
      when Symbol
        self.new @symbols[value], value
      end
    end

    define_method :to_i do
      @int
    end

    define_method :to_sym do
      @symbol
    end
  end

  def struct *fields
    model *fields

    define_singleton_method :[] do |value|
      case value
      when self
        value
      when Array
        self.new *value
      when Hash
        self.new **value
      end
    end

    define_method :to_a do
      model_fields.map{|f| send f.name }
    end
  end
end

class Array
  def extract
    size > 1 ? self : first
  end
end

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
 
    def run &block
      init if !@arena
      Kredki.instance_exec &block if block
      @runned = true
      @arena.run!
    end

    def_delegators :@arena,
      :window!,
      :window,
      :terminate!

    attr_accessor :clipboard, :keyboard, :mouse
    attr :runned

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

    def fonts=(fonts)
      fonts.each do |name, path|
        Font.load name, path
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
