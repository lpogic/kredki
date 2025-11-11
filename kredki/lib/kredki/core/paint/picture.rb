require_relative 'paint'
require_relative 'area'

module Kredki
  class Picture < Paint
    include Area

    def initialize pointer = nil
      @w = @h = 100
      @redraw_flag = true
      return super if pointer
      super Abi.picture_new
      ObjectSpace.define_finalizer(self, self.class.proc.finalize(@pointer))
    end

    def << param
      case param
      in [w, h]
        wh! w, h
      in Numeric
        wh! param
      in String
        content! param
      else
        super
      end
    end

    param def content! content, pull_size = false
      return content! yield @content if block_given?
      return if @content == content
      set_content content.to_s
      @content = content
      if pull_size
        @w, @h = get_size
        update_transform
      else
        @redraw_flag = true
      end
      update
    end

    #internal api

    def self.finalize pointer
      Abi.paint_delete pointer
    end

    def set_size x, y
      Abi.picture_set_size @pointer, x, y
    end

    def get_size
      size = Abi::Point.malloc(Fiddle::RUBY_FREE)
      Abi.picture_get_size @pointer, size
      [size.x, size.y]
    end

    def set_content content
      Abi.picture_load @pointer, content
    end

    def pxy
      [@w * 0.5, @h * 0.5]
    end

    def update
      if @redraw_flag
        @redraw_flag = false
        set_size @w, @h
        update_transform
      end
      super
    end
  end
end