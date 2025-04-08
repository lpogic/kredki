require_relative 'paint'

module Kredki
  class Picture < Paint
    include Alterable

    def initialize
      super Abi.picture_new
      ObjectSpace.define_finalizer(self, self.class.proc.finalize(@pointer))

      @w = nil
      @h = nil
    end

    param def source! source, resize: false
      return if @source == source
      set_source source.to_s
      @source = source
      if resize
        set_size @w, @h
      else
        @w, @h = *get_size
      end
      update
    end

    param def w! w
      return if @w == w
      set_size w, @h
      @w = w
      update
    end, :width

    param def h! h
      return if @h == h
      set_size @w, h
      @h = h
      update
    end, :height

    param def wh! w, h = nil
      h ||= w
      return if @w == w && @h == h
      set_size w, h
      @w = w
      @h = h
      update
    end, :size, get: def wh
      [@width, @height]
    end

    #internal api

    def self.finalize pointer
      Abi.paint_delete pointer
    end

    private

    # def set_width width
    #   if @width && @height
    #     @height = width * @height / @width
    #     @width = width
    #     Abi.picture_set_size @pointer, @width, @height
    #     update
    #   end
    # end

    # def set_height height
    #   if @width && @height
    #     @width = height * @width / @height
    #     @height = height
    #     Abi.picture_set_size @pointer, @width, @height
    #     update
    #   end
    # end

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
  end
end