require_relative 'paint'
require_relative 'area'

module Kredki
  class Picture < Paint
    include Area

    # Set content.
    def content! content, pull_size = false
      return content! yield @content if block_given?
      return if @content == content
      Pastele.picture_load @pointer, content.to_s
      @content = content
      w, h = get_size
      @aspect_ratio = w / h
      if pull_size
        @w = w
        @h = h
        update_transform
      else
        @redraw_flag = true
      end
      update
    end

    # See #content!.
    def content= param
      send_ahp :content!, param
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
      @aspect_ratio = 1.0
      @redraw_flag = true
      return super if pointer
      super Pastele.picture_new
      ObjectSpace.define_finalizer(self, Picture.finalizer(@pointer))
    end

    def self.finalizer pointer
      proc{ Pastele.paint_delete pointer }
    end

    def aspect_ratio
      @aspect_ratio
    end

    def get_size
      size = Pastele::Point.malloc(Fiddle::RUBY_FREE)
      Pastele.picture_get_size @pointer, size
      [size.x, size.y]
    end

    def pivot_xy
      [@w * 0.5, @h * 0.5]
    end

    def update
      if @redraw_flag
        @redraw_flag = false
        Pastele.picture_set_size @pointer, @w, @h
        update_transform
      end
      super
    end
  end
end