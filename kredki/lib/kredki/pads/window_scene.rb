require_relative 'service/service_filter'

module Kredki
  module Pads
    # WindowScene for Pads module.
    class WindowScene < Kredki::WindowScene
      include ServiceFilter
      
      # Add new layer.
      def layer! klass = Layer, *a, **ka, &b
        layer = klass.new
        put_pad layer
        layer.sketch_service
        layer.alter *a, **ka, &b
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
        when Hash
          filter.all?{|key, value| respond_to? key and value === send(key) }
        else
          raise "Unsupported =~ (#{filter} : #{filter.class})"
        end
      end

      # Get lower services iterator.
      def lower_iterator include_self = false
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

        layer!(RootLayer).keyboard_request
      end

      def resize_event event
        super
        sx, sy = event.size
        @services.each do |it|
          it.set_xy 0, 0
          it.set_size sx, sy
          it.size! sx, sy
        end
      end

      attr_accessor :mouse_stale

      def event_queue
        @event_queue
      end

      def layer
        @services.last
      end

      def lower
        nil
      end

      def lower_pad
        nil
      end

      def area_size_x
        window.size[0]
      end

      def area_size_y
        window.size[1]
      end

      def area_size
        window.size
      end

      def clip_size_x
        window.size[0]
      end

      def clip_size_y
        window.size[1]
      end

      def clip_size
        window.size
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
        pad.set_lower self
        push_layer pad
      end

      def push_layer layer
        return if layer.lower_pad == self
        layer.window&.remove_pad layer
        put_paint layer.scene
        layer.pad_attach self
        sx, sy = size
        layer.set_xy 0, 0
        layer.set_size sx, sy
        layer.size! sx, sy
        @services << layer
        @mouse_stale = true
        layer
      end

      def remove_upper upper, transfer = false
        @services.delete upper
        @mouse_stale = true
      end

      def remove_pad pad, transfer = false
        @services.delete pad
        @mouse_stale = true
      end
    end
  end
end