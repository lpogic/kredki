require_relative 'pad/pad'

module Kredki
  module UI
    class Layer < Pad

      def window
        action.window
      end

      def mouse_pad
        @button_pad || @mouse_pads.last
      end

      def keyboard_pad
        @keyboard_pads.last
      end

      attr :button_pad

      def def_pad ...
        action.def_pad(...)
      end

      def attach! parent
        return if @parent == parent
        raise "LOOP" if parent.lineage.find{ _1 == self }
        detach! true if @parent
        @parent = parent
        @parent&.push_pad self
      end

      def detach! transfer = false
        unless transfer
          update_keyboard_pad nil
          @button_pad = nil
          update_mouse_location false
        end
        super
      end

      #internal api

      def initialize
        super
        
        @button_pad = nil
        @keyboard_pads = []
        @mouse_pads = []
      end

      def sketch p0
        super

        keyboardy!
        color! false
      end

      def update_button_pad pad, new_button_pad
        if new_button_pad
          @button_pad = new_button_pad
        else
          if @button_pad == pad
            @button_pad = nil
          end
        end
      end

      def update_mouse_location event = nil
        xy = nil
        if event
          xy = event.xy
        elsif event.nil? && mouse.in_window?
          xy = mouse.position
        end

        if @button_pad && event
          if xy
            @button_pad.report MouseMoveEvent.new(event, *xy)
            return true
          else
            return false
          end
        else
          if xy
            included = point_pads *xy, mouse_pads = []
            @mouse_pads.reverse_each do |pad| 
              pad.report LeaveEvent.new unless mouse_pads.include? pad
            end
            mouse_pads.each do |pad|
              pad.report EnterEvent.new unless @mouse_pads.include? pad
            end
            mouse_top = mouse_pads.last
            mouse_top.report MouseMoveEvent.new(event, *xy) if mouse_top && event
            @mouse_pads = mouse_pads
            return included
          else
            @mouse_pads.reverse_each do |pad| 
              pad.report LeaveEvent.new
            end
            @mouse_pads = []
            return false
          end
        end
      end

      def update_keyboard_pad keyboard_pad
        if !keyboard_pad
          @keyboard_pads.each{|pad| pad.report FocusLoseEvent.new }
          @keyboard_pads = []
        else
          keyboard_pads = keyboard_pad.lineage.to_a.reverse
          left, both, right = *keyboard_pads.polarize(@keyboard_pads)
          right.reverse_each{|pad| pad.report FocusLoseEvent.new }
          left.each{|pad| pad.report FocusGainEvent.new }
          @keyboard_pads = keyboard_pads
        end
      end

      def point_pads x, y, pads, force = false
        if force || (mousy? && show? && include_point?(x, y))
          pads << self
          x -= @clip_scene.x
          y -= @clip_scene.y
          return true if @pads.reverse_each.find{ _1.point_pads x - _1.x, y - _1.y, pads }
          # pads >> 1
        end
        return false
      end
    end
  end
end