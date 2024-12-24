module Kredki
  module UI
    class SpacePad < Pad

      #internal api

      def sketch p0
        super
        
        area.hide!

        w! proc{ @me + @mw + (pad&.then{ _1.w } || 0) }
        h! proc{ @mn + @ms + (pad&.then{ _1.h } || 0) }
      end

      def resize e
        if e.target != self
          e.resolve
          update_size
        end
      end

      def pad
        @pads.first
      end

      def update_margin
        super.tap{ update_size }
      end

      def push_pad ...
        super.tap{ update_size }
      end

      def remove_pad pad, transfer
        super.tap{ update_size }
      end

    end
  end
end