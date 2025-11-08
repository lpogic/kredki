module Kredki
  module UI
    class CheckLabel < SpacePad
      extend Forwardable
      extend HasParams

      def check
        self[Check]
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

      def initialize
        super

        @check = new Check
        @label = new Label, "Check label"
      end

      def sketch
        super

        mi! 5
        layout! :xbc
      end

    end
  end
end