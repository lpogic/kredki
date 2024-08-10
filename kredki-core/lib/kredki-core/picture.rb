require_relative 'alterable'
require_relative 'paint'

module Kredki
  class Picture < Paint
    include Alterable

    def initialize src = nil, x = 100, y = 100, **params, &block
      super Abi.picture_new
      ObjectSpace.define_finalizer(self, self.class.proc.finalize(@pointer))

      @width = nil
      @height = nil
      @source = nil

      alter src:, x:, y:, **params, &block
    end

    def src! source
      set_source source.to_s
    end

    alias_method :src=, :src!

    def src
      @source
    end

    alias_method :source=, :src=
    alias_method :source!, :src!
    alias_method :source, :src

    def w! w
      set_w w
    end

    alias_method :w=, :w!

    def w = @width

    alias_method :width=, :w=
    alias_method :width!, :w!
    alias_method :width, :w

    def h! h
      set_h h
    end

    alias_method :h=, :h!

    def h = @height

    alias_method :height=, :h=
    alias_method :height!, :h!
    alias_method :height, :h

    #internal api

    def self.finalize pointer
      Abi.paint_delete pointer
    end

    private

    def set_width width
      if width != @width
        if @height
          @height = width * @height / @width
        end
        @width = width
        if @width && @height

          Abi.picture_set_size @pointer, @width, @height
          update
        end
      end
    end

    def set_height height
      if height != @height
        if @width
          @width = heightv * @width / @height
        end
        @height = height
        if @width && @height
          Abi.picture_set_size @pointer, @width, @height
          update
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
      if source != @source
        Abi.picture_load @pointer, source
        @source = source
        reset_size
        update
      end
    end
  end
end