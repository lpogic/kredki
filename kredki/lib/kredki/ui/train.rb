require_relative 'pad/sort_pad'

module Kredki
  module UI
    class Train < SortPad

      aliasing def sp! space
        @space != space && begin
          @space = space
          update_pads
          true
        end
      end, :sp=, :space!, :space=

      aliasing def sp
        @space
      end, :space

      aliasing def ch! car_height
        @car_height != car_height && begin
          @car_height = car_height
          update_pads
          true
        end
      end, :ch=, :car_height!, :car_height=

      aliasing def ch
        @car_height
      end, :car_height

      aliasing def cw! car_width
        @car_width != car_width && begin
          @car_width = car_width
          update_pads
          true
        end
      end, :cw=, :car_width!, :car_width=

      aliasing def cw
        @car_width
      end, :car_width

      def set_size w, h
        wch = body.w != w
        hch = body.h != h
        (wch || hch) && begin
          body.wh! w, h
          event_director.stem do
            report ResizeEvent.new wch, hch
            action.update_mouse_pad if mousy? && show?
          end
          true
        end
      end

      aliasing def sp
        @space
      end, :space

      #internal api

      class Car < SortPad

        def min_w
          @pads.first.min_w
        end

        def min_h
          @pads.first.min_h
        end

        def rebound e
        end

        def remove_pad ...
          removed = super
          if pads.empty?
            parent.remove_pad self, false
          end
          removed
        end

        def paint_index pad
          parent.paint_index self
        end
      end

      def initialize ...
        super

        @space = 0
        @car_height = @car_width = nil
      end

      def sketch p0
        super

        on_resize! do |e|
          if e.target != self
            update_pads
            e.resolve
          end
        end

        # on! ContentChangeEvent do
        #   update_pads
        # end
      end

      def rebound e
        if e.target != self
          update_pads
          e.resolve
        end
      end

      def push_pad pad, index = nil
        super(Car.new.sketch_base, index).push_pad pad
        update_pads
        pad
      end

      def remove_pad ...
        removed = super
        update_pads
        removed
      end

      def pads
        @pads.map{ _1.pads.first }
      end

      def_flag :autosized!, true, true

      def alter ...
        altering, @altering = @altering, true
        result = super
        @altering = altering
        release unless @altering
        result
      end

      def release
        after_altering, @after_altering = @after_altering, nil
        after_altering&.each do |k, v|
          send k
        end
      end

      def after_altering name
        (@after_altering ||= {})[name] = true
      end
    end

    class XTrain < Train

      def update_pads
        return after_altering :update_pads if @altering
        offset = 0

        h = @car_height || @pads.map{|p1| p1.min_h }.max || 0
        @pads.each do |p1|
          p1.x = offset
          p1.wh! @car_width || p1.min_w, h
          offset += p1.w + @space
        end
        offset -= @space if offset > 0
        alter wh: [offset, h]
      end
    end

    class YTrain < Train

      def update_pads
        return after_altering :update_pads if @altering
        offset = 0

        w = @car_width || @pads.map{|p1| p1.min_w }.max || 0
        @pads.each do |p1|
          p1.y = offset
          p1.wh! w, @car_height || p1.min_h
          offset += p1.h + @space
        end
        offset -= @space if offset > 0
        alter wh: [w, offset]
      end
    end
  end
end