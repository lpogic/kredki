require_relative 'x_handle'
require_relative 'y_handle'
require_relative 'x_accordion_layout'
require_relative 'y_accordion_layout'

module Kredki
  module Pads
    module Accordion
      class XAccordion < RectanglePad

        def accord! *a, **ka, &b
          accord_before = self[A - :accord!, reverse: true]
          accord = put RectanglePad, :accord!, {size_y: 1r}, *a, at: self[ A - XHandle ], **ka, &b
          put XHandle, accord_before: accord_before, accord_after: accord if accord_before
        end

        # :section: LEVEL 2

        def sketch
          super 

          set_fill false
          set_layout XAccordionLayout.new(Start, Start)
        end

      end#XAccordion

      class YAccordion < RectanglePad

        def accord! *a, **ka, &b
          accord_before = self[A - :accord!, reverse: true]
          accord = put RectanglePad, :accord!, {size_x: 1r}, *a, at: self[ A - YHandle ], **ka, &b
          put YHandle, accord_before: accord_before, accord_after: accord if accord_before
        end
        
        # :section: LEVEL 2

        def sketch
          super 

          set_fill false
          set_layout YAccordionLayout.new(Start, Start)
        end

      end#YAccordion
    end#Accordion
  end#Pads
end#Kredki
