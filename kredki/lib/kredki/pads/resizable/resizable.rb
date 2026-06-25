require_relative 'x_handle'
require_relative 'y_handle'
require_relative 'corner_handle'

module Kredki
  module Pads
    module Resizable
      class ResizablePad < RectanglePad
        
        def sketch
          set_fill false
          set_size_limit 8..;
          put XHandle
          put YHandle, at: End
          put CornerHandle, at: End
        end

        def put subject, *a, at: self[A - XHandle], **ka, &b
          super
        end
        
      end
    end
  end
end