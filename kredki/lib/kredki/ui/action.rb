require_relative 'pad/pad_base'
require_relative 'layer'
require 'forwardable'

module Kredki
  module UI
    class Action < Kredki::Action
      include PadBase
      extend Forwardable
      
      def initialize
        super
        
        @layers = []
      end

      def a
        self
      end

      def s
        self
      end

      def def! ...
        PadBase.def!(...)
      end

      def pad_parent
        nil
      end

      def service_parent
        nil
      end

      def sw
        w
      end

      def sh
        h
      end

      def swh
        wh
      end

      def cw
        w
      end

      def ch
        h
      end

      def cwh
        wh
      end

      def layer! klass = Layer, *a, **na, &b
        layer = klass.new
        layer.alter_begin
        layer.sketch layer
        put_pad layer
        layer.alter *a, **na, &b
        layer.alter_commit
        layer
      end

      #internal api

      def sketch p0
        super
        @mouse_stale = false

        @event_manager.manager Kredki::MouseMoveEvent, proc{|e| update_mouse_location e }
        @event_manager.manager Kredki::WindowMouseEnterEvent, proc{|e| update_mouse_location }
        @event_manager.manager Kredki::WindowMouseLeaveEvent, proc{|e| update_mouse_location }
        @event_manager.mouse_manager Kredki::MouseButtonDownEvent, [], proc{|e| mouse_event MouseButtonDownEvent.new e }
        @event_manager.mouse_manager Kredki::MouseButtonUpEvent, [], proc{|e| mouse_event MouseButtonUpEvent.new e }
        @event_manager.manager Kredki::MouseScrollEvent, proc{|e| mouse_event e }

        keyboard do
          on_down! do |e|
            p0.keyboard_event KeyDownEvent.new e
          end
          on_up! do |e|
            p0.keyboard_event KeyUpEvent.new e
          end
          on_text! do |e|
            p0.keyboard_event e
          end
        end

        on_resize! do
          w, h = *wh
          @layers.each do 
            it.set_size w, h
            it.wh! w, h
          end
        end

        on_step! do
          arrange
        end

        layer!.focus!
      end

      def arrange
        update_mouse_location if @layers.count(&:arrange) > 0 || @mouse_stale
      end

      def pad_tree
        @layers.map{ [it, it.pad_tree] }.to_h
      end

      def build *a, **na, &block
        @layers.last.alter! *a, **na, &block
      end

      def mouse_event event
        arrange
        @layers.reverse_each do |layer|
          event.target = nil
          if event.is_a? MouseButtonUpEvent
            event.drag = layer.mouse_pad_drag
          end
          layer.mouse_pad&.report event
          @event_director.resolve
          event.resolved?
        end
      end

      def update_mouse_location event = nil
        event ||= PositionEvent.new *mouse.xy
        xy = event.xy
        @layers.reverse_each do |layer|
          if event.resolved?
            layer.clear_mouse_location xy
          else
            layer.update_mouse_location event
          end
          @event_director.resolve
        end
        @mouse_stale = false
      end

      def keyboard_event event
        @layers.reverse_each.find do |layer|
          event.target = nil
          layer.keyboard_event event
          @event_director.resolve
          event.resolved?
        end
      end

      def put_pad pad
        pad.set_parent self
        push_layer pad
      end

      def push_layer layer
        return if layer.pad_parent == self
        layer.action&.remove_pad layer
        put_paint layer.scene
        layer.set_pad_parent self
        layer.set_size *wh
        layer.wh! *wh
        @layers << layer
        @mouse_stale = true
        layer
      end

      def remove_pad layer, transfer = false
        @layers.delete layer
        @mouse_stale = true
      end

      def lineage include_self = false
        []
      end
    end
  end
end