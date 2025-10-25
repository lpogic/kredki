module Kredki
  module UI
    class RadioLabelItem < SpacePad
      extend Forwardable
      extend HasParams

      def item
        self[RadioItem]
      end

      def label
        self[Label]
      end

      def << arg
        case arg
        when String
          label << arg
        else
          super
        end
      end

      #internal api

      def sketch p0
        super
        mi! 5
        layout! :xbc
      end

    end
  end
end