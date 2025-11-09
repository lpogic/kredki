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

      def pin_pad
        @pin_pad
      end

      def pin_xy
        @pin_pad&.xy
      end

      def pin_button
        @pin_pad&.button
      end

      def check_pin pad, button, top_only
        return if button != @pin_pad&.button
        return @pin_pad&.pad == pad if top_only
        @pin_pad&.pad&.in_pad? pad
      end

      def pin_pad_drag? xy
        bxy = @pin_pad&.xy and @pin_pad.pad.drag_check bxy, xy
      end

      def pin_pad_drag
        @pin_pad&.drag
      end

      def define ...
        action.define(...)
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

      def window! ...
        action.window!(...)
      end

      #internal api

      def initialize
        super
        
        @pin_pad = nil
        @keyboard_pads = []
        @mouse_pads = []
        @mouse_click_pad = nil
      end

      def sketch
        super

        keyboardy!
        color! false
      end

      def sketch_behavior
        super

        on_key_down! aim: true do |e|
          @down_keys[~e || e.keycode] = true
        end

        on_key_up! aim: true do |e|
          if @down_keys[~e || e.keycode]
            @down_keys[~e || e.keycode] = false
            keyboard_event KeyClickEvent.new e.origin
          end
        end

        on! MouseClickEvent, aim: true, do: method(:mouse_click)
      end


      class MouseClickPad
        model :pad, :xy, :timestamp, :combo
      end

      def mouse_click event
        if @mouse_click_pad && 
          @mouse_click_pad.pad == event.target && 
          !event.target.drag_check(@mouse_click_pad.xy, event.xy) && 
          event.origin.timestamp - @mouse_click_pad.timestamp < 200000000
        then
          combo = @mouse_click_pad.combo + 1
        else
          combo = 1
        end
        @mouse_click_pad = MouseClickPad.new event.target, event.xy, event.origin.timestamp, combo
      end

      def mouse_clicks
        @mouse_click_pad&.combo || 0
      end

      def arrange
        return unless @layout_broken
        @ui_layout.arrange self
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
          if !@pin_pad || !@pin_pad.button || @pin_pad.button == button
            @pin_pad = PinPad.new pad, xy, button, drag
          else 
            return false
          end
        else
          @pin_pad = nil
          layer.update_mouse_location PositionEvent.new *mouse.xy
        end
        true
      end

      def mouse_down e
        keyboard_request if keyboardy?
        pin_request e.xy, e.button_id
      end

      def mouse_up e
        pin_dispose e.button_id
        if !e.drag && include_point?(e.x, e.y)
          report MouseClickEvent.new e.origin
        end
      end

      def update_mouse_location event
        xy = event.xy

        if @pin_pad
          @pin_pad.drag ||= pin_pad_drag? xy
          @pin_pad.pad.report MouseMoveEvent.new(@pin_pad.drag, event, *xy)
          return true
        end
        arrange
        mouse_pads = []
        included = point_pads *xy, mouse_pads
        enter, stay, leave = *Util.polarize(mouse_pads, @mouse_pads)
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
          enter, no_change, leave = *Util.polarize(keyboard_pads, @keyboard_pads)
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
          return true if @pads.reverse_each.find{ it.point_pads x - it.sx, y - it.sy, pads }
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