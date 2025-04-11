module Kredki
  module UI
    class SpacePad < Pad

      #internal api

      def sketch p0
        super
        
        area.hide!
        wh! :fit
      end

      def resize e
        if e.target != self
          e.resolve
          set_size
        end
      end

      def pad
        @pads.first
      end

      def update_margin
        super.tap{ set_size }
      end

      def push_pad ...
        super.tap{ set_size }
      end

      def remove_pad pad, transfer
        super.tap{ set_size }
      end

    end
  end
end