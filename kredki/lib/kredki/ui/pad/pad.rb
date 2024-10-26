require_relative 'pad_event_manager'
require_relative 'pad_events'
require_relative 'pad_base'
require 'forwardable'
require 'kredki-core/context/context'

module Kredki
  module UI
    class Pad < Scene
      include PadBase
      include Alterable
      include Context
      include PadEvents
      extend Forwardable

      def initialize **params, &block
        super
        @action = nil
        @parent = nil
        @body = rectangle!
        @names = {}
        @event_manager = PadEventManager.new

        @pads = []

        @button_down_xy = nil
        Pad.init_flags self
      end

      def sketch p0
        on_enter!{ mouse_enter _1 }
        on_leave!{ mouse_leave _1 }
        on_mouse_button!{ mouse_button_down _1 }
        on_mouse_button_up!{ mouse_button_up _1 }
        on_mouse_move!{ mouse_move _1 }
        on! ReboundEvent do |e|
          rebound e
        end
      end

      def rebound e
        e.resolve if e.target != self
      end

      def sketched?
        @sketched
      end

      def <<(arg)
        case arg
        when Symbol
          @names[arg] = true
        when Pad
          arg.attach! self
        when Hash
          alter **arg
        when Array
          alter *arg
        when Proc
          alter &arg
        else
          raise "Unsupported << (#{arg} : #{arg.class})"
        end
      end

      def =~(filter)
        case filter
        when Symbol
          !!@names[filter]
        else
          raise "Unsupported =~ (#{filter} : #{filter.class})"
        end
      end

      def names
        @names
      end

      aliasing def name! name
        self << name
      end, :name=

      def_flag :keyboardy, true

      def mouse_button_down e
        gain_keyboard if keyboardy?
        gain_button e.xy
        e.resolve
      end

      def mouse_enter e
        e.resolve
      end

      def mouse_leave e
        e.resolve
      end

      def mouse_button_up e
        lose_button
        if @drag
          @drag = false
          report DropEvent.new e.origin
        elsif include? e.x, e.y
          report ClickEvent.new e
        end
        e.resolve
      end

      def mouse_move e
        if @drag || (@button_down_xy && ((@button_down_xy[0] - e.x) ** 2 + (@button_down_xy[1] - e.y) ** 2 > 100))
          @drag = true
          report DragEvent.new e.origin
        end
        e.resolve
      end
      
      attr :parent, :action, :body, :pads
      alias_method :a, :action

      def include? x, y
        x >= 0 && y >= 0 && x <= @body.w && y <= @body.h
      end

      def anc
        to_en{|e, b| e.parent || b }
      end

      def sanc
        to_e{|e, b| e.parent || b }
      end

      def mouse_in?
        action&.mouse_pad&.sanc&.any?{ _1 == self } || false
      end

      def mouse_top?
        action&.mouse_pad == self
      end

      def keyboard_in?
        action&.keyboard_pad&.sanc&.any?{ _1 == self } || false
      end

      def keyboard_top?
        action&.keyboard_pad == self
      end

      def button_in?
        action&.button_pad&.sanc&.any?{ _1 == self } || false
      end

      def button_top?
        action&.button_pad == self
      end

      def_flag :mousy!, true
      def_flag :focus, :set_focus, :keyboard_top?
      def_flag :mouse_focus, :set_button, :button_top?

      def drag! start_point = nil
        gain_button start_point
        @drag = true
        report DragEvent.new(nil, *action.mouse.xy)
      end

      def drag?
        !!@drag
      end

      aliasing def x! x
        set_x x
      end, :x=

      aliasing def y! y
        set_y y
      end, :y=

      def xy! x, y
        set_xy x, y
      end

      def xy=(xy)
        xy! *xy
      end

      def x global = false
        x = super()
        global ? -parent.translate(-x, 0)[0] : x
      end

      def y global = false
        y = super()
        global ? -parent.translate(0, -y)[1] : y
      end

      def xy global = false
        xy = super()
        xy = -parent.translate(-xy[0], -xy[1]) if global
        xy
      end

      aliasing def w! w
        set_size w, h
      end, :w=, :width!, :width=

      aliasing def h! h
        set_size w, h
      end, :h=, :height!, :height=

      aliasing def wh! w, h = nil
        set_size w, h || w
      end, :size!

      aliasing def wh=(wh)
        case wh
        when Array
          wh! *wh
        else
          wh! wh
        end
      end, :size=

      def new_pad klass = Pad, *a, _index: nil, **na, &b
        push_pad(klass.new.sketch_base, _index).alter(*a, **na, &b)
      end

      class Next
        model :pad

        def respond_to? name
          pad.parent&.respond_to? name
        end

        def method_missing name, *a, **na, &b
          index = pad.parent&.paint_index pad
          if index
            pad.parent&.send name, *a, _index: index + 1, **na, &b
          end
        end
      end

      def next!
        Next.new self
      end

      def index
        parent&.paint_index self
      end

      def push_pad pad, paint_index = nil, clip = true
        pad_parent = pad.parent
        paint_state = push_paint pad, true, paint_index
        pad.set_parent self
        if paint_index
          start = [paint_state.index, @pads.size - 1].min
          pad_index = (start..0).step(-1).find do |i|
            @paints[@pads[i]].index < paint_state.index
          end || -1
          @pads.insert pad_index + 1, pad
        else
          @pads << pad
        end
        if clip
          pad.clip! body
        elsif pad_parent
          pad.clip! nil
        end
        report ContentChangeEvent.new
        event_director.stem do
          action.update_mouse_pad
        end if mousy? && mouse_in? || pad.mousy? && pad.mouse_in?
        pad
      end

      def remove_pad pad, transfer
        removed = @pads.delete pad
        if removed && !transfer
          pad.composite! false
          report ContentChangeEvent.new
          event_director.stem do
            action.update_mouse_pad
          end if mousy? && mouse_in?
        end
        removed
      end

      def clear_pads
        pads, @pads = @pads, []
        pads.each do |pad|
          pad.detach! true
          pad.composite! false
        end
        unless pads.empty?
          report ContentChangeEvent.new
          event_director.stem do
            action.update_mouse_pad
          end if mousy? && mouse_in?
        end
      end

      def attach! parent
        return if @parent == parent
        raise "LOOP" if parent.sanc.find{ _1 == self }
        detach! true if @parent
        @parent = parent
        @parent&.push_pad self
      end

      def detach! transfer = false
        super()
        @parent&.remove_pad self, transfer
        @parent = nil
      end

      def use! extension, *a, **na, &b
        extension.plug_into self, *a, **na, &b if extension.respond_to? :plug_into
      end

      def_delegators :@body,
        :color!, :color=,
        :h, :height, 
        :w, :width,
        :wh, :size,
        :r!, :r=, :radius!, :radius=,
        :stroke_width!, :stroke_width=, :stroke_color!, :stroke_color=

      #internal api

      def sketch_base
        sketch self unless @sketched
        @sketched = true
        self
      end
      
      def set_size w, h
        body.wh!(w, h) && begin
          event_director.stem do
            report ResizeEvent.new
            report ReboundEvent.new
            action.update_mouse_pad if mousy? && show?
          end
          true
        end
      end
      
      def set_x x
        super && move_common
      end

      def set_y y
        super && move_common
      end

      def set_xy x, y
        super && move_common
      end

      def min_w
        w
      end

      def min_h
        h
      end

      def move_common
        event_director.stem do
          action.update_mouse_pad if mousy? && show?
          report MoveEvent.new
        end if sketched?
        true
      end

      def set_show show
        if show
          report ShowEvent.new
          @pads.each &:show_propagate
        else
          report HideEvent.new
          @pads.each &:hide_propagate
        end
        super
      end

      def show_propagate
        if show?
          report ShowEvent.new
          @pads.each &:show_propagate
        end
      end

      def hide_propagate
        if show?
          report HideEvent.new
          @pads.each &:hide_propagate
        end
      end

      def point_pads x, y, pads, force = false
        if force || (mousy? && show? && include?(x, y))
          pads << self
          @pads.reverse_each.find{ _1.point_pads x - _1.x, y - _1.y, pads }
          return true
        end
        return false
      end

      def gain_keyboard
        pad = keyboardy? ? self : each_pad(deep_first: true).find{ _1.keyboardy? }
        action.update_keyboard_pad pad
      end

      def lose_keyboard
        action.update_keyboard_pad nil if keyboard_in?
      end

      def focus_lose
        lose_keyboard
      end

      def focus_gain
        gain_keyboard
      end

      def set_focus set
        set ? gain_keyboard : lose_keyboard
      end

      def gain_button xy = nil
        @button_down_xy = xy
        action.gain_button self
      end

      def lose_button
        @button_down_xy = nil
        action.lose_button self
      end

      def set_button set
        set ? gain_button : lose_button
      end

      def translate x, y
        parent.translate x - self.x, y - self. y
      end

      def autosized?
        false
      end

      def update_child_xy_on_resize?
        false
      end

      def report event
        event.target = self
        ancs = sanc.to_a
        ed = event_director
        if event.is_a? MouseEvent
          ed.stem do
            ancs.reverse_each do |pad|
              ed.push_block event do
                event.x -= pad.x
                event.y -= pad.y
              end
              ed.push event, pad, :aim
            end
            ancs.each do |pad|
              ed.push event, pad, :alt
              ed.push_block event do
                event.x += pad.x
                event.y += pad.y
              end
            end
          end
        else
          ed.stem do
            ancs.reverse_each do |pad|
              ed.push event, pad, :aim
            end
            ancs.each do |pad|
              ed.push event, pad, :alt
            end
          end
        end
      end

      def resolve event, mode = :default
        @event_manager.resolve event, mode
      end

      def set_parent parent
        @parent = parent
        set_action parent&.action
      end

      def set_action action
        @action = action
        @pads.each{ _1.set_action action }
      end
    end
  end
end