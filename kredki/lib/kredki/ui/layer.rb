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

      def def! ...
        action.def!(...)
      end

      def detach! transfer = false
        unless transfer
          update_keyboard_pad nil
          @button_pad = nil
          update_mouse_location false
        end
        super
      end

      def layer! ...
        action.layer!(...)
      end

      def weak_tag tag, weakref
        define_singleton_method tag do
          obj = weakref.__getobj__
          weakref.weakref_alive? ? obj : nil
        end
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

      def arrange
        return unless @layout_broken
        @_layout.arrange self
        @layout_broken = false
        true
      end

      def break_layout
        @layout_broken = true
      end

      def keyboard_event event
        if !event.resolved? && show?
          keyboard_pad&.report event
        end
      end

      def update_button_pad pad, new_button_pad
        if new_button_pad
          @button_pad = new_button_pad
        else
          if @button_pad == pad
            @button_pad = nil
            update_mouse_location
          end
        end
      end

      def mouse_button_down e
        if e.button == :primary
          gain_keyboard if keyboardy?
          gain_button e.xy
        end
      end

      def mouse_button_up e
        lose_button
        if @drag
          @drag = false
          report DropEvent.new e.origin
        elsif include_point?(e.x, e.y) && e.button == :primary
          report ClickEvent.new e.origin
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
          event ||= nil
          if xy
            arrange
            included = point_pads *xy, mouse_pads = []
            @mouse_pads, mouse_pads = mouse_pads, @mouse_pads
            mouse_pads.reverse_each do |pad| 
              pad.report LeaveEvent.new(event, *xy), false unless @mouse_pads.include? pad
            end
            @mouse_pads.each do |pad|
              pad.report EnterEvent.new(event, *xy), false unless mouse_pads.include? pad
            end
            mouse_top = @mouse_pads.last
            mouse_top.report MouseMoveEvent.new(event, *xy) if mouse_top && event
            return included
          else
            @mouse_pads.reverse_each do |pad| 
              pad.report LeaveEvent.new(event, *xy), false
            end
            @mouse_pads = []
            return false
          end
        end
      end

      def update_keyboard_pad keyboard_pad
        if !keyboard_pad
          @keyboard_pads.each{|pad| pad.report FocusLoseEvent.new, false }
          @keyboard_pads = []
        else
          keyboard_pads = keyboard_pad.pad_lineage.to_a.reverse
          left, both, right = *keyboard_pads.polarize(@keyboard_pads)
          right.reverse_each{|pad| pad.report FocusLoseEvent.new, false }
          left.each{|pad| pad.report FocusGainEvent.new, false }
          @keyboard_pads = keyboard_pads
        end
      end

      def point_pads x, y, pads, force = false
        if force || (mousy? && show? && include_point?(x, y))
          pads << self
          x -= @clip_scene.x
          y -= @clip_scene.y
          return true if @pads.reverse_each.find{ _1.point_pads x - _1.sx, y - _1.sy, pads }
        end
        return false
      end

      def set_parent parent
        return if @parent == parent
        @parent = parent
        set_action parent&.action
      end

      def set_pad_parent parent
        return if @pad_parent == parent
        @pad_parent = parent
      end
    end
  end
end