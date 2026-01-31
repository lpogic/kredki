require_relative 'paint'
require_relative 'area'

module Kredki
  class Picture < Paint
    include Area

    # Set content.
    def content! content, pull_size = false
      return content! yield @content if block_given?
      return if @content == content
      renew if @content        
      Pastele.picture_load @pointer, content.to_s
      @content = content
      @ow, @oh = get_size
      if pull_size
        @w = @ow
        @h = @oh
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

    # Get origin width and height.
    def wh_origin
      [@ow, @oh]
    end

    # Find shape of the picture.
    def find_shape id
      paint = Pastele.picture_accessor_get @pointer, id
      if !paint.null? && Pastele.paint_get_type(paint) == 1
        shape = Shape.new(true, paint)
        shape.set_masking self
        shape
      end
    end

    # Traverse shape tree of the picture.
    def each_shape &block
      callback = Fiddle::Closure::BlockCaller.new Fiddle::TYPE_INT, [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP] do |paint, data|
        if Pastele.paint_get_type(paint) == 1
          shape = Shape.new(true, paint)
          shape.set_masking self
          block.call shape
        end
        1
      end
      Pastele.paint_accessor_traverse @pointer, callback
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
      @ow = @oh = 100.0
      @redraw_flag = true
      return super if pointer
      super Pastele.picture_new
      ObjectSpace.define_finalizer(self, Picture.finalizer(@pointer))
    end

    def renew
      pointer = Pastele.picture_new
      @scene.renew_paint self, @pointer, pointer
      Pastele.paint_delete @pointer
      @pointer = pointer
      ObjectSpace.define_finalizer(self, Picture.finalizer(@pointer))
    end

    def self.finalizer pointer
      proc{ Pastele.paint_delete pointer }
    end

    def aspect_ratio
      @ow / @oh
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