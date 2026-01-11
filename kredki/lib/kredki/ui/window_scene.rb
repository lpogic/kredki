require_relative 'service/service_filter'
require_relative 'layer'

module Kredki
  module UI
    # WindowScene for UI module.
    class WindowScene < Kredki::WindowScene
      include ServiceFilter
      
      # Add new layer.
      def layer! klass = Layer, *a, **na, &b
        layer = klass.new
        layer.sketch_service
        put_pad layer
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
          filter.all?{ self =~ it }
        else
          raise "Unsupported =~ (#{filter} : #{filter.class})"
        end
      end

      # Get ancestors.
      def lineage include_self = false
        []
      end

      # :section: LEVEL 2

      def initialize
        super
        
        @services = []
      end

      def sketch
        super
        @mouse_stale = false

        @event_manager.manager MousePointerMoveEvent, proc{|e| update_mouse_location e }
        @event_manager.manager MousePointerEnterEvent, proc{|e| update_mouse_location }
        @event_manager.manager MousePointerLeaveEvent, proc{|e| update_mouse_location }
        @event_manager.mouse_manager MouseButtonPressEvent, [], proc{|e| mouse_event e }
        @event_manager.mouse_manager MouseButtonReleaseEvent, [], proc{|e| mouse_event e }
        @event_manager.manager MouseWheelSpinEvent, proc{|e| mouse_event e }

        on_key_press do |e|
          keyboard_event e
        end
        on_key_release do |e|
          keyboard_event e
        end
        on_text_input do |e|
          keyboard_event e
        end

        on_window_resize do
          w, h = *wh
          @services.each do 
            it.set_xy 0, 0
            it.set_size w, h
            it.wh! w, h
          end
        end

        layer!.keyboard_request
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
        @services.map{ [it, it.pad_tree] }.to_h
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
        @services.reverse_each do |layer|
          if event.closed?
            layer.clear_mouse_location xy
          else
            event = layer.update_mouse_location event
          end
          @event_queue.process
        end
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