require_relative 'pad/pad'

module Kredki
  module UI
    class Layer < Pad

      class MousePad
        model :pad, :xy, :button, :drag
      end

      def window
        action.window
      end

      def mouse_pad
        @mouse_pad&.pad || @mouse_pads.last
      end

      def keyboard_pad
        @keyboard_pads.last
      end

      def check_key_down key
        !!@down_keys[key]
      end

      def mouse_down_xy
        @mouse_pad&.xy
      end

      def check_mouse_pad pad, button, lineage = false
        lineage ? @mouse_pad&.pad&.pad_lineage&.any?{ it == self } : (@mouse_pad&.pad == pad) \
        and !button || @mouse_pad.button == button
      end

      def mouse_pad_drag? xy
        bxy = @mouse_pad&.xy and (bxy[0] - xy[0]) ** 2 + (bxy[1] - xy[1]) ** 2 > 100
      end

      def mouse_pad_drag
        @mouse_pad&.drag
      end

      def def! ...
        action.def!(...)
      end

      def detach! transfer = false
        unless transfer
          update_keyboard_pad nil
          @mouse_pad = nil
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
        
        @mouse_pad = nil
        @keyboard_pads = []
        @mouse_pads = []
      end

      def sketch p0
        super

        keyboardy!
        color! false

        on_key_down! aim: true do |e|
          @down_keys[~e] = true
        end

        on_key_up! aim: true do |e|
          if @down_keys[~e]
            @down_keys[~e] = false
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

      def break_layout
        @layout_broken = true
      end

      def keyboard_event event
        if !event.resolved? && show? && (kp = keyboard_pad)
          event.target = kp
          kp.report event
        end
      end
      
      def update_mouse_pad pad, new_mouse_pad, xy = nil, button = nil, drag = false
        if new_mouse_pad
          @mouse_pad = MousePad.new new_mouse_pad, xy, button, drag
        else
          if @mouse_pad&.pad == pad
            @mouse_pad = nil
          end
        end
      end

      def mouse_down e
        gain_keyboard if keyboardy?
        gain_button e.xy
      end

      def mouse_up e
        lose_button
        if !e.drag && include_point?(e.x, e.y)
          report MouseClickEvent.new e.origin
        end
      end

      def update_mouse_location event
        xy = event.xy

        if @mouse_pad
          @mouse_pad.drag ||= mouse_pad_drag? xy
          @mouse_pad.pad.report MouseMoveEvent.new(@mouse_pad.drag, event, *xy)
          return true
        end
        arrange
        mouse_pads = []
        included = point_pads *xy, mouse_pads
        enter, stay, leave = *mouse_pads.polarize(@mouse_pads)
        @mouse_pads = mouse_pads

        leave.reverse_each{ it.report LeaveEvent.new(event, *xy), false }
        enter.reverse_each{ it.report EnterEvent.new(event, *xy), false }
        mouse_top = @mouse_pads.last
        mouse_top.report MouseMoveEvent.new(false, event, *xy) if mouse_top
        return included
      end

      def clear_mouse_location xy
        unless @mouse_pads.empty?
          mouse_pads = @mouse_pads
          @mouse_pads = []
          mouse_pads.reverse_each{ it.report LeaveEvent.new(nil, *xy), false }
        end
      end

      def update_keyboard_pad keyboard_pad
        if !keyboard_pad
          @keyboard_pads.each{|pad| pad.report FocusLoseEvent.new, false }
          @keyboard_pads = []
        else
          keyboard_pads = keyboard_pad.pad_lineage.to_a.reverse
          gain, no_change, lose = *keyboard_pads.polarize(@keyboard_pads)
          @keyboard_pads = keyboard_pads
          lose.reverse_each{ it.report FocusLoseEvent.new, false }
          gain.reverse_each{ it.report FocusGainEvent.new, false }
        end
        @down_keys = {}
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
      end

      def set_pad_parent parent
        return if @pad_parent == parent
        @pad_parent = parent
      end
    end
  end
end