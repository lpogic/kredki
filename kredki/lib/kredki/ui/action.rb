require_relative 'pad/pad_base'
require_relative 'pad/pad'
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
        self
      end

      def mouse_pad
        @mouse_pads.last
      end

      def keyboard_pad
        @keyboard_pads.last
      end

      attr_accessor :button_pad
      
      def_delegators :@background,
        :color!, :color=,
        :push_pad, :remove_pad, :new_pad,
        :mouse_top, :keyboard_top, :button_top

      #internal api

      def sketch p0
        super

        mouse do
          on_move! do |e|
            p0.update_mouse_pad e.x, e.y, e
            e.forward
          end
        
          on_button! do |e|
            p0.mouse_pad&.report MouseButtonDownEvent.new e
            e.forward
          end
        
          on_button_up! do |e|
            p0.mouse_pad&.report MouseButtonUpEvent.new e
            e.forward
          end

          on_drop! do |e|
            p0.mouse_pad&.report DropEvent.new e, x, y
            e.forward
          end

          on_scroll! do |e|
            p0.mouse_pad&.report e
            e.forward
          end
        end

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

        @background = push_paint(Pad.new).alter parent: self, action: action, color: :black
        on_resize! do
          @background.size = window.size
        end.resolve
      end

      def update_mouse_pad x, y, event = nil
        if @button_pad && event
          @button_pad.report MouseMoveEvent.new(event, x, y)
        else
          @background.point_pads(x, y, mouse_pads = {})
          @mouse_pads.reverse_each do |pad| 
            pad.report LeaveEvent.new unless mouse_pads[pad]
          end
          mouse_pads_keys = mouse_pads.keys
          mouse_pads_keys.each do |pad|
            pad.report EnterEvent.new unless @mouse_pads.include? pad
          end
          mouse_top = mouse_pads_keys.last
          mouse_top.report MouseMoveEvent.new(event, *mouse_pads[mouse_top]) if mouse_top
          @mouse_pads = mouse_pads_keys
        end
      end

      def update_keyboard_pad keyboard_pad
        if !keyboard_pad
          @keyboard_pads.each{|pad| pad.report FocusLoseEvent.new }
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