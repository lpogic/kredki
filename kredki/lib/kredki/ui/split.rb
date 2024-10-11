module Kredki
  module UI
    class Split < Pad

      def initialize ...
        super
      end

      def sketch p0
        body.hide!
      end

      def push_pad pad, next_pad = nil
        super(Slice.new, next_pad).sketch_base.push_pad pad
        update_slices
        pad
      end

      def remove_pad pad, transfer
        super pad.parent, false
        pad.parent.remove_pad pad, transfer
        update_slices
      end
    end

    class XSplit < Split
      def update_slices
        size = @pads.size
        @pads.each_with_index do |pad, i|
          pad.alter x: 1.0 * i / size, w: 1.0 / size
        end if size > 0
      end
    end

    class YSplit < Split
      def update_slices
        size = @pads.size
        @pads.each_with_index do |pad, i|
          pad.alter y: 1.0 * i / size, h: 1.0 / size
        end if size > 0
      end
    end
  end
end