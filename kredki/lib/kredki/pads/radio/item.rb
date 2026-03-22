module Kredki
  module Pads
    module Radio
      # Radio item.
      class Item < SpacePad

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
            set_subject feature
          else
            super
          end
        end

        # :section: LEVEL 2

        def initialize
          super

          @button = put ItemButton, :button!
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
      end
    end
  end
end