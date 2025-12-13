module Kredki
  module UI
    # Check with label.
    class LabeledCheck < SpacePad

      # Get check.
      def check
        self[Check]
      end

      # Get label.
      def label
        self[Label]
      end

      # Push the feature.
      def << arg
        case arg
        when String
          label << arg
        else
          super
        end
      end

      # :section: LEVEL 2

      def initialize
        super

        @check = new Check
        @label = new Label, "Check label"
      end

      def sketch
        super

        margin_i! 5
        layout! :xsc
      end

    end
  end
end