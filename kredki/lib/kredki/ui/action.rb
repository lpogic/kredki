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
        
        @pads = []
      end

      def a
        self
      end

      def s
        self
      end

      def def_pad name, klass = nil, *def_a, **def_na, &def_b
        PadBase.def_pad name, klass, *def_a, **def_na, &def_b
        # if block
        #   PadBase.define_method name do |*a, **na, &b|
        #     pad = instance_exec a, na, b, self, &block
        #     pad.alter! name, *a, **na, &b if klass
        #     pad
        #   end
        # else
        #   PadBase.define_method name do |*a, **na, &b|
        #     new_pad klass, name, *a, **na, &b
        #   end
        # end
      end

      def parent
        nil
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
        push_pad layer
        layer.alter *a, **na, &b
        layer.alter_commit
        layer
      end

      #internal api

      def sketch p0
        super

        @event_manager.manager Kredki::MouseMoveEvent, proc{|e| update_mouse_location e }
        @event_manager.manager Kredki::WindowMouseEnterEvent, proc{|e| update_mouse_location }
        @event_manager.manager Kredki::WindowMouseLeaveEvent, proc{|e| update_mouse_location }
        @event_manager.mouse_manager Kredki::MouseButtonDownEvent, [], proc{|e| mouse_event MouseButtonDownEvent.new e }
        @event_manager.mouse_manager Kredki::MouseButtonUpEvent, [], proc{|e| mouse_event MouseButtonUpEvent.new e }
        @event_manager.manager Kredki::MouseScrollEvent, proc{|e| mouse_event e }

        keyboard do
          on_down! do |e|
            p0.keyboard_event e
          end
          on_up! do |e|
            p0.keyboard_event e
          end
          on_text! do |e|
            p0.keyboard_event e
          end
        end

        on_resize! do
          w, h = *wh
          @pads.each{ _1.wh! w, h }
        end

        layer!.focus!
      end

      def build *a, **na, &block
        @pads.last.alter *a, **na, &block
      end

      def set_size_p
      end

      def arrange
      end

      def mouse_event event
        @pads.reverse_each do |layer|
          layer.mouse_pad&.report event
        end
      end

      def update_mouse_location event = nil
        @pads.reverse_each.find do |layer|
          layer.update_mouse_location event
        end
      end

      def keyboard_event event
        @pads.reverse_each do |layer|
          layer.keyboard_event event
        end
      end

      def push_pad layer
        push_paint layer.scene
        layer.set_parent self
        layer.wh! *wh
        @pads << layer
        layer
      end

      def remove_pad layer, transfer = false
        @pads.delete layer
      end

      def lineage include_self = false
        []
      end
    end
  end
end