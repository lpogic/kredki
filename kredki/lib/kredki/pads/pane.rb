require_relative 'service/service_filter'

module Kredki
  module Pads
    # Pane of Pads module.
    class Pane < Kredki::Pane
      include ServiceFilter
      
      # Add new layer.
      def layer! ...
        put(Layer, __method__, ...)
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

      # Get lower services iterator - empty because Pane is always the lowest.
      def lower_iterator include_self = false
        []
      end

      class << self
        attr_accessor :sketch_layer

        # Define custom base layer for this Pane subclass.
        def layer! &block
          self.sketch_layer = Class.new Layer
          sketch_layer.define_method :sketch do
            super()
            pane.sketch_layer_block self, &block
          end
        end
      end

      # :section: LEVEL 2

      self.sketch_layer = Layer

      def initialize *a, **ka
        super()
        
        @event_queue = EventQueue.new
        @services = []
        @mouse_stale = false
        @sketch_a = a
        @sketch_ka = ka
      end

      def sketch_layer_block layer, &block
        layer.instance_exec *@sketch_a, **@sketch_ka, &block
        @sketch_a = @sketch_ka = nil
      end

      def sketch
        super
        
        put(self.class.sketch_layer).keyboard_request
      end

      def behavior
        super
        on_mouse_move do: method(:mouse_move_event)
        on_mouse_enter do: method(:mouse_enter_event)
        on_mouse_leave do: method(:mouse_leave_event)
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
      end

      def context_service
        super
        @services.last
      end

      def resize_event event
        super
        sx, sy = event.size
        @services.each do |it|
          it.update_xy 0, 0
          it.set_size sx, sy
          it.update_size sx, sy
        end
      end

      attr_accessor :mouse_stale

      def event_queue
        @event_queue
      end

      def layer
        @services.last
      end

      def lower ...
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

      def mouse_event event
        arrange
        @services.reverse_each do |layer|
          event.target = nil
          event = layer.mouse_event event
          @event_queue.process
        end
      end

      def mouse_move_event event
        update_mouse_location event
      end

      def mouse_enter_event event
        update_mouse_location
      end

      def mouse_leave_event event
        update_mouse_location
      end

      def update_mouse_location event = nil
        event ||= PositionEvent.new *window.mouse_xy
        xy = event.xy
        cursor = nil
        @services.reverse_each do |layer|
          if event.closed
            layer.clear_mouse_location xy
          else
            event = layer.update_mouse_location event
            cursor ||= layer.layer_mouse_cursor
          end
          @event_queue.process
        end
        Kredki.mouse.set_cursor cursor
        @mouse_stale = false
      end

      def keyboard_event event
        @services.reverse_each.find do |layer|
          event.target = nil
          layer.keyboard_event event
          @event_queue.process
          event.closed
        end
      end

      def joystick_event event
        @services.reverse_each.find do |layer|
          event.target = nil
          layer.joystick_event event
          @event_queue.process
          event.closed
        end
      end

      def put subject, *a, at: nil, **ka, &b
        case subject
        when Class
          put subject.new, *a, at: at, **ka, &b
        else
          layer = subject
          put_layer layer, at if at != false
          layer.set *a, **ka, &b
          layer
        end
      end

      def put_layer layer, at = nil
        layer.pad_attach self, at
        case at
        when Integer
          paint_state = put_paint layer.scene, false
          @services.insert at, pad
        when Layer
          paint_state = put_paint layer.scene, false, at.scene
          @services.insert @services.index(at), layer
        else
          paint_state = put_paint layer.scene, false
          @services << layer
        end
        layer.sketch_service
        sx, sy = window.size
        layer.update_xy 0, 0
        layer.set_size sx, sy
        layer.update_size sx, sy
        layer&.break_layout
        @mouse_stale = true
        layer
      end

      def layers
        @services
      end

      def delete_upper upper, system_call
        @services.delete upper
        @mouse_stale = true
      end

      def delete_pad pad, transfer = false
        @services.delete pad
        @mouse_stale = true
      end

      def each_service reverse, direct_call, &block
        if reverse
          @services.reverse_each &block
        else
          @services.each &block
        end
      end
    end
  end
end