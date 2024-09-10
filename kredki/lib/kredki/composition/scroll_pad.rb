require_relative 'slide'

module Kredki
  class ScrollPad < Pad

    def sketch p0
      super

      @pad = nil
      @yscroll = custom_pad!(YSlide).alter h: 100, w: 10, y: 0, x: w - 10
      @xscroll = custom_pad!(XSlide).alter w: 100, h: 10, x: 0, y: h - 10

      @yscroll.on_edit! do
        p0.pad&.y! ((100 - p0.pad.h) * @yscroll.value).round
      end

      @xscroll.on_edit! do
        p0.pad&.x! ((100 - p0.pad.w + 100) * @xscroll.value).round
      end
    end

    attr :pad

    def push_pad pad, next_pad = nil
      if sketched?
        next_pad ||= @yscroll
        @pad&.detach!
      end
      super pad, next_pad
      if sketched?
        @pad = pad
      end
      pad
    end

    def remove_pad pad
      @pad = nil if pad == @pad
      super
    end
  end
end