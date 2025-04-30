module Kredki
  module UI
    class SpacePad < Pad

      def << arg
        case arg
        in Numeric
          m! arg
        in [Numeric, Numeric]
          m! *arg
        in [Numeric, Numeric, Numeric, Numeric]
          m! *arg
        else
          super
        end
      end

      #internal api

      def sketch p0
        super
        
        area.hide!
        wh! :fit
      end
    end
  end
end