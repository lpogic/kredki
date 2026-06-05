require_relative 'checkbox_button'

module Kredki
  module Pads
    # Checkbox.
    class Checkbox < SpacePad

      feature :selected
      
      def set_selected ...
        @button.set_selected(...)
      end
      
      def selected
        @button.selected
      end
      
      def mixed_set feature
        case feature
        when String
          (upper(Label) or default_label).set feature
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
        set_layout :xsc, 5
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