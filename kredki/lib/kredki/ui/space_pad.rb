module Kredki
  module UI
    class SpacePad < Pad

      #internal api

      def sketch p0
        super
        
        area.hide!
        wh! :fit
      end
    end
  end
end