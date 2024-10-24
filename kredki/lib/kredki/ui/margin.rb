require_relative 'pad/sort_pad'

module Kredki
  module UI
    class Margin < SortPad

      def << arg
        case arg
        when Array
          space! *arg
        else
          super
        end
      end

      aliasing def sl! s
        space! s, @r, @t, @b
      end, :space_left!, :sl=, :space_left=

      aliasing def sr! s
        space! @l, s, @t, @b
      end, :space_right!, :sr=, :space_right=

      aliasing def st! s
        space! @l, @r, s, @b
      end, :space_top!, :st=, :space_top=

      aliasing def sb! s
        space! @l, @r, @t, s
      end, :space_bottom!, :sb=, :space_bottom=

      aliasing def sl
        @l
      end, :space_left

      aliasing def sr
        @r
      end, :space_right

      aliasing def st
        @t
      end, :space_top

      aliasing def sb
        @b
      end, :space_bottom

      aliasing def sx! s
        space! s, s, @t, @b
      end, :space_x, :sx=, :space_x=

      aliasing def sy! s
        space! @l, @r, s, s
      end, :space_y, :sy=, :space_y=

      aliasing def sp! *space, &block
        space = [block.call(sp, space)].flatten if block
        l, r, t, b = case space.size
        when 0 then [0, 0, 0, 0]
        when 1 then space * 4
        when 2 then [space[0], space[0], space[1], space[1]]
        when 3 then [*space, space[2]]
        else space
        end
        (@l != l || @r != r || @t != t || @b != b) && begin
          @l = l
          @r = r
          @t = t
          @b = b
          update_car
          true
        end
      end, :space!

      aliasing def sp= space
        space! *space
      end, :space=

      aliasing def sp
        [@l, @r, @t, @b]
      end, :space

      #internal api

      def initialize ...
        super

        @car = nil
        @l = @r = @t = @b = 0
      end

      def sketch p0
        super
        
        on_resize! do |e|
          if e.target != self
            update_car
            e.resolve
          end
        end
      end

      def pad
        @pads.first
      end

      def push_pad pad, next_pad = nil
        pad&.detach!
        super
        update_car
        pad
      end

      def remove_pad pad, transfer
        removed = super
        update_car
        removed
      end

      def update_car
        pad = self.pad
        w = @l + @r
        h = @t + @b
        if pad
          pad.xy! @l, @t
          w += pad.w
          h += pad.h
        end
        set_size w, h
      end

      def autosized?
        true
      end

    end
  end
end