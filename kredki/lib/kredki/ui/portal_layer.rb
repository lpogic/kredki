module Kredki
  module UI
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
    
        def input_id
          @source.input_id
        end
    
        def param
          @source.param
        end
      end
      
      class PortalMouseButtonPushEvent < MouseButtonPushEvent
        include PortalMouseButtonEvent
      end
      
      class PortalMouseButtonFreeEvent < MouseButtonFreeEvent
        include PortalMouseButtonEvent
      end
    
      attr_accessor :entry
      attr_accessor :exit

      def mouse_event event
        case event
        when MouseButtonPushEvent
          PortalMouseButtonPushEvent.new *translated_xy(event.xy), event
        when MouseButtonFreeEvent
          PortalMouseButtonFreeEvent.new *translated_xy(event.xy), event
        else
          event
        end
      end

      def translated_xy xy
        lx, ly = window.translate *xy, @entry
        @exit.translate lx * @exit.sw / @entry.sw, ly * @exit.sh / @entry.sh
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