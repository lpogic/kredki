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
      c = content.to_s
      raise "File #{c} not found." unless File.exist? c
      Pastele.picture_load @pointer, c
      @content = content
      @original_size_x, @original_size_y = fetch_size
      if pull_size
        @size_x = @original_size_x
        @size_y = @original_size_y
        update_transform
      else
        @redraw_flag = true
      end
      update
    end

    # See #content!.
    def content= param
      send_bundle :content!, param
    end

    # Get content.
    def content
      @content
    end

    # Get original size.
    def original_size
      [@original_size_x, @original_size_y]
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
      in [x, y]
        size! x, y
      in Numeric
        size! feature
      in String
        content! feature
      else
        super
      end
    end

    # :section: LEVEL 2

    def initialize pointer = nil
      @size_x = @size_y = 100
      @original_size_x = @original_size_y = 100.0
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
      @original_size_x / @original_size_y
    end

    def fetch_size
      size = Pastele::Point.malloc(Fiddle::RUBY_FREE)
      Pastele.picture_get_size @pointer, size
      [size.x, size.y]
    end

    def pivot_xy
      [@size_x * 0.5, @size_y * 0.5]
    end

    def update
      if @redraw_flag
        @redraw_flag = false
        Pastele.picture_set_size @pointer, @size_x, @size_y
        update_transform
      end
      super
    end
  end
end