require_relative 'checkbox_button'

module Kredki
  module Pads
    # Checkbox.
    class Checkbox < SpacePad

      # Set whether is selected.
      def set_selected ...
        @button.set_selected(...)
      end

      # See #set_selected.
      def selected= param
        @button.selected = param
      end

      # Get whether is selected.
      def selected
        @button.selected
      end

      # Set a feature recognized by its class.
      def << feature
        case feature
        when String
          (find Label or default_label) << feature
          self.subject ||= feature
        else
          super
        end
      end

      # :section: LEVEL 2

      def initialize
        super

        @button = default_checkbox_button
      end

      def sketch
        super

        set_size Fit
        set_spacer 5
        set_layout :xsc
      end

      def repaint event = nil
        set_opacity in_disabled ? 3/4r : 1r
      end

      def default_checkbox_button
        put CheckboxButton do
          on_click do
            set_selected Not
          end
        end
      end

      def default_label
        put Label
      end

    end
  end
end