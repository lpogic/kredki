module Kredki
  module Pads
    class PortalLayer < Layer

      # :section: LEVEL 2

      module PortalMouseEvent
        def x
          @x
        end

        def y
          @y
        end

        def xy
          [@x, @y]
        end

        def param
          xy
        end

        def initialize x, y, ...
          super(nil, ...)
          @x = x
          @y = y
        end
      end

      class PortalMousePointerMoveEvent < MousePointerMoveEvent
        include PortalMouseEvent
      end

      module PortalMouseButtonEvent
        include PortalMouseEvent
    
        def button
          @source.button
        end
    
        def code
          @source.code
        end
    
        def param
          @source.param
        end
      end
      
      class PortalMouseButtonPressEvent < MouseButtonPressEvent
        include PortalMouseButtonEvent
      end
      
      class PortalMouseButtonReleaseEvent < MouseButtonReleaseEvent
        include PortalMouseButtonEvent
      end
    
      attr_accessor :entry
      attr_accessor :exit

      def mouse_event event
        case event
        when MouseButtonPressEvent
          PortalMouseButtonPressEvent.new *translated_xy(event.xy), event
        when MouseButtonReleaseEvent
          PortalMouseButtonReleaseEvent.new *translated_xy(event.xy), event
        else
          event
        end
      end

      def translated_xy xy
        lx, ly = window.translate *xy, @entry
        @exit.translate lx * @exit.area_size_x / @entry.area_size_x, ly * @exit.area_size_y / @entry.area_size_y
      end

      def update_mouse_location event
        xy = event.xy

        @entry.layer.arrange
        @mouse_pads, last_mouse_pads = [], @mouse_pads
        @entry.layer.point_pads *xy, @mouse_pads
        if @mouse_pads.last != @entry
          pad_detach
          return event
        end
        PortalMousePointerMoveEvent.new *translated_xy(event.xy), event
      end

    end
  end
end