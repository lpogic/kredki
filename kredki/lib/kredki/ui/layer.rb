require_relative 'pad/pad'

module Kredki
  module UI
    class Layer < ShapePad

      class PinPad
        model :pad, :xy, :button, :drag
      end

      def window
        action.window
      end

      def mouse_pad
        @pin_pad&.pad || @mouse_pads.last
      end

      attr :mouse_pads

      def keyboard_pad
        @keyboard_pads.last
      end

      def check_key_down key
        !!@down_keys[key]
      end

      def pin_xy
        @pin_pad&.xy
      end

      def check_pin pad, button, top_only
        return if button != @pin_pad&.button
        return @pin_pad&.pad == pad if top_only
        @pin_pad&.pad&.in_pad? pad
      end

      def mouse_pad_drag? xy
        bxy = @pin_pad&.xy and (bxy[0] - xy[0]) ** 2 + (bxy[1] - xy[1]) ** 2 > 100
      end

      def mouse_pad_drag
        @pin_pad&.drag
      end

      def def! ...
        action.def!(...)
      end

      def detach! transfer = false
        unless transfer
          update_keyboard_pad nil
          @pin_pad = nil
        end
        super
      end

      def layer! ...
        action.layer!(...)
      end

      #internal api

      def initialize
        super
        
        @pin_pad = nil
        @keyboard_pads = []
        @mouse_pads = []
      end

      def sketch p0
        super

        keyboardy!
        color! false

        on_key_down! aim: true do |e|
          @down_keys[~e || e.keycode] = true
        end

        on_key_up! aim: true do |e|
          if @down_keys[~e || e.keycode]
            @down_keys[~e || e.keycode] = false
            keyboard_event KeyClickEvent.new e.origin
          end
        end
      end

      def arrange
        return unless @layout_broken
        @_layout.arrange self
        @layout_broken = false
        true
      end

      def sx
        0
      end

      def sy
        0
      end

      def sxy
        [0, 0]
      end

      def break_layout
        @layout_broken = true
      end

      def keyboard_event event
        if !event.resolved? && show? && (kp = keyboard_pad)
          event.target = kp
          kp.report event
        end
      end
      
      def update_pin_pad pad, xy = nil, button = nil, drag = false
        if pad
          @pin_pad = PinPad.new pad, xy, button, drag
        else
          @pin_pad = nil
        end
        true
      end

      def mouse_down e
        keyboard_request if keyboardy?
        pin_request e.xy
      end

      def mouse_up e
        pin_dispose
        if !e.drag && include_point?(e.x, e.y)
          report MouseClickEvent.new e.origin
        end
      end

      def update_mouse_location event
        xy = event.xy

        if @pin_pad
          @pin_pad.drag ||= mouse_pad_drag? xy
          @pin_pad.pad.report MouseMoveEvent.new(@pin_pad.drag, event, *xy)
          return true
        end
        arrange
        mouse_pads = []
        included = point_pads *xy, mouse_pads
        enter, stay, leave = *mouse_pads.polarize(@mouse_pads)
        @mouse_pads = mouse_pads

        leave.reverse_each{ it.report MouseLeaveEvent.new(event, *xy), false }
        enter.reverse_each{ it.report MouseEnterEvent.new(event, *xy), false }
        mouse_top = @mouse_pads.last
        mouse_top.report MouseMoveEvent.new(false, event, *xy) if mouse_top
        return included
      end

      def clear_mouse_location xy
        unless @mouse_pads.empty?
          mouse_pads = @mouse_pads
          @mouse_pads = []
          mouse_pads.reverse_each{ it.report MouseLeaveEvent.new(nil, *xy), false }
        end
        @pin_pad&.pad&.pin_dispose

      end

      def update_keyboard_pad keyboard_pad = self
        if !keyboard_pad
          @keyboard_pads.each{|pad| pad.report FocusLeaveEvent.new, false }
          @keyboard_pads = []
        else
          keyboard_pads = keyboard_pad.pad_lineage.to_a.reverse
          enter, no_change, leave = *keyboard_pads.polarize(@keyboard_pads)
          @keyboard_pads = keyboard_pads
          leave.reverse_each{ it.report FocusLeaveEvent.new, false }
          enter.reverse_each{ it.report FocusEnterEvent.new, false }
        end
        @down_keys = {}
        true
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

      def set_parent parent, at = nil
        return if @parent == parent
        @parent = parent
      end

      def set_pad_parent parent
        return if @pad_parent == parent
        @pad_parent = parent
      end
    end
  end
end