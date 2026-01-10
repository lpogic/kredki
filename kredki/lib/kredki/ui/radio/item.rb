module Kredki
  module UI
    module Radio
      # Radio item.
      class Item < SpacePad

        # Get item button.
        def button
          @button
        end

        # Set whether is checked.
        def checked! ...
          button.checked!(...)
        end

        # See #checked!.
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

        # Push the feature.
        def << feature
          case feature
          when String
            new Label, feature
          else
            super
          end
        end

        # :section: LEVEL 2

        def initialize
          super

          @button = new ItemButton
        end

        def sketch
          super

          h! :fit
          mi! 8
          layout! :xsc
        end
      end
    end
  end
end