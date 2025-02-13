require_relative 'paint'

module Kredki
  class Picture < Paint
    include Alterable

    def initialize
      super Abi.picture_new
      ObjectSpace.define_finalizer(self, self.class.proc.finalize(@pointer))

      @width = nil
      @height = nil
    end

    param def source! source
      source = source.to_s
      @source != source and set_source source
    end

    param def w! w
      @width != w and set_width w
    end, :width

    param def h! h
      @height != h and set_height h
    end, :height

    param def wh! w, h = nil
      h ||= w
      @height != h || @width != w and set_size w, h
    end, :size, get: def wh
      [@width, @height]
    end

    #internal api

    def self.finalize pointer
      Abi.paint_delete pointer
    end

    private

    def set_width width
      @width = width and @height and begin
        @height = width * @height / @width
        Abi.picture_set_size @pointer, @width, @height
        update
      end
    end

    def set_height height
      @height = height and @width and begin
        @width = height * @width / @height
        Abi.picture_set_size @pointer, @width, @height
        update
      end
    end

    def set_size width, height
      @width = width and @height = height and begin
        Abi.picture_set_size @pointer, @width, @height
        update
      end
    end

    def reset_size
      size = Abi::Point.malloc(Fiddle::RUBY_FREE)
      Abi.picture_get_size @pointer, size
      @width = size.x
      @height = size.y
    end

    def set_source source
      Abi.picture_load @pointer, source
      @source = source
      reset_size
      update
    end
  end
end