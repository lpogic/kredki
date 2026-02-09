require_relative 'service/service_filter'
require_relative 'layer'

module Kredki
  module Pads
    # WindowScene for Pads module.
    class WindowScene < Kredki::WindowScene
      include ServiceFilter
      
      # Add new layer.
      def layer! klass = Layer, *a, **na, &b
        layer = klass.new
        put_pad layer
        layer.sketch_service
        layer.alter *a, **na, &b
        layer
      end

      # Match self with +filter+.
      def =~ filter
        case filter
        when nil
          true
        when Module, Proc
          filter === self
        when Array
          filter.all?{|it| self =~ it }
        else
          raise "Unsupported =~ (#{filter} : #{filter.class})"
        end
      end

      # Get ancestors.
      def lineage include_self = false
        []
      end

      # Save window as PNG image.
      def to_png filepath
        arrange
        @scene.to_png filepath
      end

      # :section: LEVEL 2

      def initialize
        super
        
        @event_queue = EventQueue.new
        @services = []
      end

      def sketch
        super
        @mouse_stale = false

        on_mouse_move do: method(:update_mouse_location)
        @event_manager.manager MousePointerEnterEvent, proc{|e| update_mouse_location }
        @event_manager.manager MousePointerLeaveEvent, proc{|e| update_mouse_location }
        on_mouse_press do: method(:mouse_event)
        on_mouse_release do: method(:mouse_event)
        on_mouse_scroll do: method(:mouse_event)
        on_drop do: method(:mouse_event)
        on_key_press do: method(:keyboard_event)
        on_key_release do: method(:keyboard_event)
        on_text_input do: method(:keyboard_event)
        on_joystick_press do: method(:joystick_event)
        on_joystick_release do: method(:joystick_event)
        on_joystick_move do: method(:joystick_event)
        on_joystick_switch do: method(:joystick_event)

        on_resize{ resize *wh }
        on_expose{ resize *wh }

        layer!.keyboard_request
      end

      def resize w, h
        @services.each do |it|
          it.set_xy 0, 0
          it.set_size w, h
          it.wh! w, h
        end
      end

      attr_accessor :mouse_stale

      def event_queue
        @event_queue
      end

      def layer
        @services.last
      end

      def pad_parent
        nil
      end

      def service_parent
        nil
      end

      def sw
        window.wh[0]
      end

      def sh
        window.wh[1]
      end

      def swh
        window.wh
      end

      def clw
        window.wh[0]
      end

      def clh
        window.wh[1]
      end

      def clwh
        window.wh
      end

      def tick ms
        super
        arrange
      end

      def arrange
        update_mouse_location if @services.count(&:arrange) > 0 || @mouse_stale
      end

      def pad_tree
        @services.map{|it| [it, it.pad_tree] }.to_h
      end

      def build_context
        @services.last
      end

      def mouse_event event
        arrange
        @services.reverse_each do |layer|
          event.target = nil
          event = layer.mouse_event event
          @event_queue.process
        end
      end

      def update_mouse_location event = nil
        event ||= PositionEvent.new *window.mouse_xy
        xy = event.xy
        cursor = nil
        @services.reverse_each do |layer|
          if event.closed?
            layer.clear_mouse_location xy
          else
            event = layer.update_mouse_location event
            cursor ||= layer.layer_mouse_cursor
          end
          @event_queue.process
        end
        Kredki.mouse.cursor! cursor
        @mouse_stale = false
      end

      def keyboard_event event
        @services.reverse_each.find do |layer|
          event.target = nil
          layer.keyboard_event event
          @event_queue.process
          event.closed?
        end
      end

      def joystick_event event
        @services.reverse_each.find do |layer|
          event.target = nil
          layer.joystick_event event
          @event_queue.process
          event.closed?
        end
      end

      def put_pad pad
        pad.set_parent self
        push_layer pad
      end

      def push_layer layer
        return if layer.pad_parent == self
        layer.window&.remove_pad layer
        put_paint layer.scene
        layer.set_pad_parent self
        w, h = wh
        layer.set_xy 0, 0
        layer.set_size w, h
        layer.wh! w, h
        @services << layer
        @mouse_stale = true
        layer
      end

      # def remove_service layer, transfer = false
      #   @services.delete layer
      #   @mouse_stale = true
      # end

      def remove_pad pad, transfer = false
        @services.delete pad
        @mouse_stale = true
      end
    end
  end
end