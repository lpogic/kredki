require_relative 'paint'
require_relative 'area'

module Kredki
  class Picture < Paint
    include Area

    # Set content.
    def content! content, pull_size = false
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

    # See #content!.
    def content= param
      Array === param ? (content! *param) : (content! param)
    end

    # Get content.
    def content
      @content
    end

    # Push the feature.
    def << feature
      case feature
      in [w, h]
        wh! w, h
      in Numeric
        wh! feature
      in String
        content! feature
      else
        super
      end
    end

    # :section: LEVEL 2

    def initialize pointer = nil
      @w = @h = 100
      @redraw_flag = true
      return super if pointer
      super Pastele.picture_new
      ObjectSpace.define_finalizer(self, self.class.proc.finalize(@pointer))
    end

    def self.finalize pointer
      Pastele.paint_delete pointer
    end

    def set_size x, y
      Pastele.picture_set_size @pointer, x, y
    end

    def get_size
      size = Pastele::Point.malloc(Fiddle::RUBY_FREE)
      Pastele.picture_get_size @pointer, size
      [size.x, size.y]
    end

    def set_content content
      Pastele.picture_load @pointer, content
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