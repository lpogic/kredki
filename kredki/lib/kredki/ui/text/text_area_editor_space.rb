require 'forwardable'

module Kredki
  module UI
    class TextAreaEditorSpace < SpacePad
      extend Forwardable

      #internal api

      def initialize
        super
      
        @theme = nil
        new_pad TextAreaEditor
      end


      def sketch p0
        super

        mousy!
        wh! 5
      end

      def point_pads x, y, pads, force = false
        if force || (mousy? && show? && include_point?(x, y))
          pads << self
          pad = self.pad
          pad.point_pads x - pad.x, y - pad.y, pads, true
          return true
        end
        return false
      end
    end
  end
end