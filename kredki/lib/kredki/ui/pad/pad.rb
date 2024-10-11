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
        @body = rectangle! x: 0, y: 0
        @names = {}
        @event_manager = PadEventManager.new

        @pads = []

        @button_down_xy = nil
        Pad.init_flags self
      end

      def sketch p0
        on_enter!{ default_on_mouse_enter _1 }
        on_leave!{ default_on_mouse_leave _1 }
        on_mouse_button!{ default_on_mouse_button_down _1 }
        on_mouse_button_up!{ default_on_mouse_button_up _1 }
        on_mouse_move!{ default_on_mouse_move _1 }
      end

      def sketched?
        @sketched
      end

      def <<(arg)
        case arg
        when Symbol
          if arg.end_with? "!"
            @names.delete arg[...-1].to_sym
          else
            @names[arg] = true
          end
        when Pad
          arg.attach! self
        else
          raise "Unsupported << (#{arg} : #{arg.class})"
        end
      end

      def =~(filter)
        case filter
        when Symbol
          if filter.end_with? "!"
            !@names[filter[...-1].to_sym]
          else
            !!@names[filter]
          end
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

      def_flag :keyboardy!, true

      def default_on_mouse_button_down e
        gain_keyboard if keyboardy?
        gain_button e.xy
      end

      def default_on_mouse_enter e
      end

      def default_on_mouse_leave e
      end

      def default_on_mouse_button_up e
        lose_button
        if @drag
          @drag = false
          report DropEvent.new e.origin
        elsif include? e.x, e.y
          report ClickEvent.new e
        end
      end

      def default_on_mouse_move e
        if @drag || (@button_down_xy && ((@button_down_xy[0] - e.x) ** 2 + (@button_down_xy[1] - e.y) ** 2 > 100))
          @drag = true
          report DragEvent.new e.origin
        end
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
        action.mouse_pad&.sanc&.any?{ _1 == self } || false
      end

      def mouse_top?
        action.mouse_pad == self
      end

      def keyboard_in?
        action.keyboard_pad&.sanc.any?{ _1 == self } || false
      end

      def keyboard_top?
        action.keyboard_pad == self
      end

      def button_in?
        action.button_pad&.sanc.any?{ _1 == self } || false
      end

      def button_top?
        action.button_pad == self
      end

      def_flag :mousy!, true
      def_flag :focus, :set_focus, :keyboard_top?
      def_flag :mouse_focus, :set_button, :button_top?

      def drag!
        gain_button
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

      def new_pad klass
        push_pad(klass.new).sketch_base
      end

      def push_pad pad, next_pad = nil, clip = true
        pad_parent = pad.parent
        index = next_pad && @paints[next_pad]&.index
        push_paint pad, true, index
        pad.set_parent self
        if index
          pad_index = ([index, @pads.size].min...0).step(-1).find do |i|
            @paints[@pads[i - 1]].index < index
          end || 0
          @pads.insert pad_index, pad
        else
          @pads << pad
        end
        if clip
          pad.clip! body
        elsif pad_parent
          pad.clip! nil
        end
        action.event_director.stem do
          action.update_mouse_pad *mouse.position, false
        end if mousy? && mouse_in? || pad.mousy? && pad.mouse_in?
        pad
      end

      def remove_pad pad, transfer
        @pads.delete pad
        if !transfer
          pad.composite! false
          action.event_director.stem do
            action.update_mouse_pad *mouse.position, false
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
        :r!, :r=, :radius!, :radius=

      #internal api

      def sketch_base
        sketch self
        @sketched = true
        self
      end
      
      def set_size w, h
        body.wh!(w, h) && begin
          action.event_director.stem do
            report ResizeEvent.new
            action.update_mouse_pad *mouse.position if mousy? && show?
          end
          true
        end
      end
      
      def set_x x
        super && begin
          action.event_director.stem do
            action.update_mouse_pad *mouse.position if mousy? && show?
            report MoveEvent.new
          end if mousy? && sketched?
          true
        end
      end

      def set_y y
        super && begin
          action.event_director.stem do
            action.update_mouse_pad *mouse.position if mousy? && show?
            report MoveEvent.new
          end if mousy? && sketched?
          true
        end
      end

      def set_xy x, y
        super && begin
          action.event_director.stem do
            action.update_mouse_pad *mouse.position, false
            report MoveEvent.new
          end if mousy? && sketched?
          true
        end
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
        action.update_keyboard_pad self
      end

      def lose_keyboard
        action.update_keyboard_pad nil if action.keyboard_pad == self
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

      def reduce_child_w?
        false
      end

      def reduce_child_h?
        false
      end

      def report event
        event.target = self
        ancs = sanc.to_a
        ed = action.event_director
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
      end
    end
  end
end