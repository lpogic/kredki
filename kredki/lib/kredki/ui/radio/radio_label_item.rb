module Kredki
  module UI
    class RadioLabelItem < SpacePad

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

      # :section: LEVEL 2

      def sketch
        super

        mi! 5
        layout! :xbc
      end

    end
  end
end