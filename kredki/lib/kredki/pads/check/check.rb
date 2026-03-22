require_relative 'check_button'

module Kredki
  module Pads
    # Check.
    class Check < SpacePad

      # Get item button.
      def button
        @button
      end

      # Set whether is checked.
      def set_checked ...
        button.set_checked(...)
      end

      # See #set_checked.
      def checked= param
        button.checked = param
      end

      # Get whether is checked.
      def checked
        button.checked
      end

      # See #checked.
      def checked?
        button.checked?
      end

      # Set a feature recognized by its class.
      def << feature
        case feature
        when String
          (find Label or put Label) << feature
        else
          super
        end
      end

      # :section: LEVEL 2

      def initialize
        super

        @button = nil
      end

      def sketch
        super

        @button = put CheckButton do
          on_click do
            set_checked Not
          end
        end

        set size_y: Fit
        set spacer: 8
        set layout: :xsc
      end

      def repaint event = nil
        set opacity: in_disabled ? 3/4r : 1r
      end

    end
  end
end