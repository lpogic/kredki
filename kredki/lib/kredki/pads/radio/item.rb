module Kredki
  module Pads
    module Radio
      # Radio item.
      class Item < SpacePad

        def mixed_set feature
          case feature
          when String
            direct_upper(Label)&.set feature or default_text feature
            self.subject ||= feature
          else
            super
          end
        end

        feature :selected # Whether radio item is the selected one.

        def set_selected ...
          @button.set_selected(...)
        end

        def selected
          @button.selected
        end

        # :section: LEVEL 2

        def initialize
          super

          @button = default_item_button
        end

        def attach lower, at: nil
          pad_detach
          pad_attach lower, at: at
        end

        def sketch
          super

          set_size_y Fit
          set_layout :xsc, 8
        end

        def repaint event = nil
          set_opacity in_disabled ? 3/4r : 1r
        end

        def default_item_button
          put ItemButton
        end

        def default_text text
          put Label, text
        end

      end
    end
  end
end