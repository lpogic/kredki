require_relative 'pad/pad_base'
require_relative 'pad/root_pad'
require 'forwardable'

module Kredki
  module UI
    class Action < Kredki::Action
      include PadBase
      extend Forwardable
      
      def initialize
        super
        
        @button_pad = nil
        @keyboard_pads = []
        @mouse_pads = []
      end

      def a
        self
      end

      def parent
        nil
      end

      def mouse_pad
        @button_pad || @mouse_pads.last
      end

      def keyboard_pad
        @keyboard_pads.last
      end

      attr :button_pad
      
      def_delegators :@background,
        :[], :each_pad,
        :color!, :color=,
        :push_pad, :remove_pad, :new_pad,
        :on_mouse_button!, 
        :on_scroll!

      #internal api

      def gain_button pad
        @button_pad = pad
      end

      def lose_button pad
        @button_pad = nil if @button_pad == pad
        update_mouse_pad *mouse.xy
      end

      def sketch p0
        super

        @event_manager.manager Kredki::MouseMoveEvent, proc{|e| p0.update_mouse_pad e.x, e.y, e }
        @event_manager.mouse_manager Kredki::MouseButtonDownEvent, [], proc{|e| p0.mouse_pad&.report MouseButtonDownEvent.new e }
        @event_manager.mouse_manager Kredki::MouseButtonUpEvent, [], proc{|e| p0.mouse_pad&.report MouseButtonUpEvent.new e }
        @event_manager.manager Kredki::MouseScrollEvent, proc{|e| 
          p0.mouse_pad&.report e
          e.forward
        }

        keyboard do
          on_down! do |e|
            p0.keyboard_pad&.report e
            e.forward
          end

          on_up! do |e|
            p0.keyboard_pad&.report e
            e.forward
          end

          on_text! do |e|
            p0.keyboard_pad&.report e
            e.forward
          end
        end

        @background = push_paint(RootPad.new).alter color: :black do
          set_action p0
          on_mouse_button! do
            p0.update_keyboard_pad nil
          end
        end
        on_resize! do
          @background.size = window.size
        end.resolve
      end

      def update_mouse_pad x, y, event = nil
        if @button_pad && event
          @button_pad.report MouseMoveEvent.new(event, x, y)
        else
          @background.point_pads(x, y, mouse_pads = [])
          @mouse_pads.reverse_each do |pad| 
            pad.report LeaveEvent.new unless mouse_pads.include? pad
          end
          mouse_pads.each do |pad|
            pad.report EnterEvent.new unless @mouse_pads.include? pad
          end
          mouse_top = mouse_pads.last
          mouse_top.report MouseMoveEvent.new(event, x, y) if mouse_top && event
          @mouse_pads = mouse_pads
        end
      end

      def update_keyboard_pad keyboard_pad
        if !keyboard_pad
          @keyboard_pads.each{|pad| pad.report FocusLoseEvent.new }
          @keyboard_pads = []
        else
          keyboard_pads = keyboard_pad.sanc.to_a.reverse
          pol = keyboard_pads.polarize @keyboard_pads
          pol.last.reverse_each{|pad| pad.report FocusLoseEvent.new }
          pol.first.each{|pad| pad.report FocusGainEvent.new }
          @keyboard_pads = keyboard_pads
        end
      end
    end
  end
end