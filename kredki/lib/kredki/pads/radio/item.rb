module Kredki
  module Pads
    module Radio
      # Radio item.
      class Item < SpacePad

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
            find(Label)&.set feature or default_text feature
            self.subject ||= feature
          else
            super
          end
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
          set_spacer 8
          set_layout :xsc
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