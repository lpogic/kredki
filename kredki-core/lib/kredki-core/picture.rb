require_relative 'paint'
require_relative 'area'

module Kredki
  class Picture < Paint
    include Alterable
    include Area

    def initialize
      super Abi.picture_new
      ObjectSpace.define_finalizer(self, self.class.proc.finalize(@pointer))

      @w = 100
      @h = 100
      @redraw_flag = true
    end

    def << param
      case param
      in [w, h]
        wh! w, h
      in Numeric
        wh! param
      in String
        source! param
      else
        raise ArgumentError.new "#{param} #{param.class}"
      end
    end

    param def source! source, pull_size = false
      return if @source == source
      set_source source.to_s
      @source = source
      if pull_size
        @w, @h = *get_size 
      else
        @redraw_flag = true
      end
      update
    end

    #internal api

    def self.finalize pointer
      Abi.paint_delete pointer
    end

    def set_size width, height
      Abi.picture_set_size @pointer, width, height
    end

    def get_size
      size = Abi::Point.malloc(Fiddle::RUBY_FREE)
      Abi.picture_get_size @pointer, size
      [size.x, size.y]
    end

    def set_source source
      Abi.picture_load @pointer, source
    end

    def update
      if @redraw_flag
        @redraw_flag = false
        set_size @w, @h
      end
      super
    end
  end
end