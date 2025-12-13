module Kredki
  module UI
    module Radio
      # Radio item with label.
      class LabeledItem < SpacePad

        # Get radio item.
        def item
          self[Item]
        end

        # Get radio item label.
        def label
          self[Label]
        end

        # Push the feature.
        def << feature
          case feature
          when String
            label << feature
          else
            super
          end
        end

        # :section: LEVEL 2

        def sketch
          super

          margin_i! 5
          layout! :xsc
        end
      end
    end
  end
end