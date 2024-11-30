module Kredki
  module UI
    class SpacePad < Pad

      def << arg
        case arg
        when Numeric
          wh! arg
        when Array
          wh! *arg
        else
          super
        end
      end

      aliasing def wb! s
        set_space s, @we, @hb, @he
      end, :width_begin!, :wb=, :width_begin=

      aliasing def we! s
        set_space @wb, s, @hb, @he
      end, :width_end!, :we=, :width_end=

      aliasing def hb! s
        set_space @wb, @we, s, @he
      end, :height_begin!, :hb=, :height_begin=

      aliasing def he! s
        set_space @wb, @we, @hb, s
      end, :height_end!, :he=, :height_end=

      aliasing def wb
        @wb
      end, :width_begin

      aliasing def wq
        @wq
      end, :width_end

      aliasing def hb
        @hb
      end, :height_begin

      aliasing def he
        @he
      end, :height_end

      aliasing def w! b, e = b
        set_space b, e, @hb, @he
      end, :width, :w=, :width=

      aliasing def h! b, e = b
        set_space @wb, @we, b, e
      end, :height, :h=, :height=

      aliasing def wh! *wh
        wb, we, hb, he = case wh.size
        when 0 then [0, 0, 0, 0]
        when 1 then wh * 4
        when 2 then [wh[0], wh[0], wh[1], wh[1]]
        when 3 then [*wh, wh[2]]
        else wh
        end
        set_space wb, we, hb, he
      end

      aliasing def wh= wh
        wh! *wh
      end

      aliasing def wh
        [@wb, @we, @hb, @he]
      end

      #internal api

      def initialize ...
        super
        
        @wb = @we = @hb = @he = 0
      end

      def sketch p0
        super
        
        area.hide!
      end

      def resize e
        update_pad unless e.target == self
      end

      def pad
        @pads.first
      end

      def push_pad ...
        pad&.detach! true
        super
        update_pad
        pad
      end

      def remove_pad pad, transfer
        removed = super
        update_pad unless transfer
        removed
      end

      def set_space wb, we, hb, he
        (@wb != wb || @we != we || @hb != hb || @he != he) && begin
          @wb = wb
          @we = we
          @hb = hb
          @he = he
          update_pad
          true
        end
      end

      def update_pad
        return if altered? :update_pad
        pad = self.pad
        w = @wb + @we
        h = @hb + @he
        if pad
          pad.xy! @wb, @hb
          w += pad.w
          h += pad.h
        end
        set_size w, h and report ResizeEvent.new
      end

      def autosized?
        true
      end

      def update_child_xy_on_resize?
        true
      end

    end
  end
end