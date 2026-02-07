module Kredki
  module Pads
    # Kredki::Pads::WindowScene child. Layers form a layer stack. Pads from higher layers are processed before pads from lower ones.
    class Layer < RectanglePad

      # Get repeated click counter value. The counter is reset when the next click occurs after a specified time interval, 
      # or the click target is a different pad, or the click location is beyond a specified distance limit from the previous one.
      def mouse_clicks
        @click_data&.combo || 0
      end

      # Detach from window.
      def detach transfer = false
        unless transfer
          update_keyboard_pad nil
          @pin_data = nil
          @click_data = nil
        end
        super
      end

      # Extend API at runtime.
      def define ...
        Pads.define(...)
      end

      def carry_focus_on_tab!
        on_key_press :tab do |event|
          next_pad = layer.keyboard_pad&.then do |p0|
            each_pad(reverse: event.shift?, deep: true)
              .lazy
              .drop_while{|p1| p0 != p1 }
              .drop(1)
              .filter{|it| it.keyboardy? && !it.disabled? && it.show? }
              .first
          end || each_pad(reverse: event.shift?, deep: true)
            .lazy
            .filter{|it| it.keyboardy? && !it.disabled? && it.show? }
            .first
          next_pad&.keyboard_request
        end
      end

      # :section: LEVEL 2

      class PinData
        
        def initialize pad, xy, button, drag
          @pad = pad
          @xy = xy
          @button = button
          @drag = drag
        end

        attr_accessor :pad
        attr_accessor :xy
        attr_accessor :button
        attr_accessor :drag

      end

      class ClickData

        def initialize pad, xy, timestamp, combo
          @pad = pad
          @xy = xy
          @timestamp = timestamp
          @combo = combo
        end

        attr_accessor :pad
        attr_accessor :xy
        attr_accessor :timestamp
        attr_accessor :combo

      end

      def initialize
        super
        
        @pin_data = nil
        @keyboard_pads = []
        @mouse_pads = []
        @click_data = nil
      end

      def sketch
        super

        keyboardy!
        fill! false
      end

      def behavior
        super
        
        on_key_press early: true do |e|
          @pressed_keys[e.param || e.code] = true
        end

        on_key_release early: true do |e|
          if @pressed_keys[e.param || e.code]
            @pressed_keys[e.param || e.code] = false
            keyboard_event KeyClickEvent.new e
          end
        end

        on_mouse_click early: true, do: method(:mouse_click)
      end

      def break_layout
        @layout_broken = true
      end

      def arrange
        return unless @layout_broken
        @pads_layout.arrange self
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

      def keyboard_pad
        @keyboard_pads.last
      end

      def keyboard_event event
        if !event.closed? && show? && (kp = keyboard_pad)
          event.target = kp
          kp.report event
        end
      end

      def update_keyboard_pad keyboard_pad = self
        if !keyboard_pad
          @keyboard_pads.each{|pad| pad.report FocusLeaveEvent.new, false }
          @keyboard_pads = []
        else
          keyboard_pads = keyboard_pad.pad_lineage.to_a.reverse
          enter, no_change, leave = *Util.polarize(keyboard_pads, @keyboard_pads)
          @keyboard_pads = keyboard_pads
          leave.reverse_each{|it| it.report FocusLeaveEvent.new, false }
          enter.reverse_each{|it| it.report FocusEnterEvent.new, false }
        end
        @pressed_keys = {}
        true
      end

      def check_key_pressed key
        !!@pressed_keys[key]
      end

      def joystick_event event
        if !event.closed?
          report event
        end
      end

      def mouse_pad
        @pin_data&.pad || @mouse_pads.last
      end

      def mouse_event e
        e.drag = @pin_data&.drag if e.is_a? MouseButtonReleaseEvent
        mouse_pad&.report e
        e
      end

      def update_mouse_location event
        xy = event.xy

        if @pin_data
          drag = @pin_data.drag || ((@pin_data.drag = layer_drag_check xy) && :start)
          if drag
            event = MousePointerDragEvent.new nil, event
            event.button = @pin_data.button
            event.start = true if drag == :start
          end
          @pin_data.pad.report event
          return event
        end

        arrange
        @mouse_pads, last_mouse_pads = [], @mouse_pads
        point_pads *xy, @mouse_pads
        enter, stay, leave = *Util.polarize(@mouse_pads, last_mouse_pads)
        leave.reverse_each{|it| it.report MousePointerLeaveEvent.new(event), false }
        enter.reverse_each{|it| it.report MousePointerEnterEvent.new(event), false }
        @mouse_pads.last&.report event
        event
      end

      def point_pads x, y, pads, force = false
        if force || (mousy? && show? && include_point?(x, y))
          pads << self
          x -= @clip_scene.x
          y -= @clip_scene.y
          return true if @pads.reverse_each.find{|it| it.point_pads x - it.sx, y - it.sy, pads }
        end
        return false
      end

      def clear_mouse_location xy
        unless @mouse_pads.empty?
          mouse_pads = @mouse_pads
          @mouse_pads = []
          mouse_pads.reverse_each{|it| it.report MousePointerLeaveEvent.new(nil, *xy), false }
        end
        @pin_data&.pad&.pin_dispose
      end

      def layer_mouse_cursor
        if @pin_data
          @pin_data.pad.mouse_cursor
        else
          @mouse_pads.reverse_each.find{|it| it.mouse_cursor }&.mouse_cursor
        end
      end

      def mouse_press e
        keyboard_request if keyboardy?
        pin_request e.xy, e.button.id
      end

      def mouse_release e
        pin_dispose e.button.id
        if !e.drag && include_point?(e.x, e.y)
          report MouseButtonClickEvent.new e
        end
      end

      def mouse_click event
        if @click_data && 
          @click_data.pad == event.target && 
          !event.target.drag_check(@click_data.xy, event.xy) && 
          event.timestamp - @click_data.timestamp < 200000000
        then
          combo = @click_data.combo + 1
        else
          combo = 1
        end
        @click_data = ClickData.new event.target, event.xy, event.timestamp, combo
      end

      def layer_check_mouse_in pad
        mouse_pad&.check_mouse_in pad
      end

      def pin_pad
        @pin_data&.pad
      end

      def pin_xy
        @pin_data&.xy
      end

      def pin_button
        @pin_data&.button
      end

      def pin_check pad, button, top_only
        return if button != @pin_data&.button
        return @pin_data&.pad == pad if top_only
        @pin_data&.pad&.in_pad? pad
      end
      
      def update_pin_pad pad, xy = nil, button = nil, drag = false
        if pad
          if !@pin_data || !@pin_data.button || @pin_data.button == button
            @pin_data = PinData.new pad, xy, button, drag
          else 
            return false
          end
        else
          @pin_data = nil
          xy ||= window.mouse_xy
          layer.update_mouse_location PositionEvent.new *xy
        end
        true
      end      

      def layer_drag_check xy
        bxy = @pin_data&.xy and @pin_data.pad.drag_check bxy, xy
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