require_relative 'alterable'
require_relative 'paint'

module Kredki
  class Picture < Paint
    include Alterable

    def initialize
      super Abi.picture_new
      ObjectSpace.define_finalizer(self, self.class.proc.finalize(@pointer))

      @w = nil
      @h = nil
      @source = nil
    end

    aliasing def s! source
      set_source source.to_s
    end, :s=, :source!, :source=

    aliasing def s
      @source
    end, :source

    aliasing def w! w
      set_w w
    end, :w=, :width!, :width=

    aliasing def w
      @width
    end, :width

    aliasing def h! h
      set_h h
    end, :h=, :height!, :height=

    aliasing def h
      @height
    end, :height

    aliasing def wh
      [@width, @height]
    end, :size

    #internal api

    def self.finalize pointer
      Abi.paint_delete pointer
    end

    private

    def set_width width
      width != @width && begin
        if @height
          @height = width * @height / @width
        end
        @width = width
        @width && @height && begin
          Abi.picture_set_size @pointer, @width, @height
          update
          true
        end
      end
    end

    def set_height height
      height != @height && begin
        if @width
          @width = height * @width / @height
        end
        @height = height
        @width && @height && begin
          Abi.picture_set_size @pointer, @width, @height
          update
          true
        end
      end
    end

    def reset_size
      size = Abi::Point.malloc(Fiddle::RUBY_FREE)
      Abi.picture_get_size @pointer, size
      @width = size.x
      @height = size.y
    end

    def set_source source
      source != @source && begin
        Abi.picture_load @pointer, source
        @source = source
        reset_size
        update
        true
      end
    end
  end
end