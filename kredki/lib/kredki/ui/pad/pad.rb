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
        gain_button
        @button_down_xy = e.xy
      end

      def default_on_mouse_enter e
      end

      def default_on_mouse_leave e
      end

      def default_on_mouse_button_up e
        lose_button
        @button_down_xy = nil
        if @drag
          @drag = false
          report DropEvent.new e
        elsif include? e.x, e.y
          report ClickEvent.new e
        end
      end

      def default_on_mouse_move e
        if @drag || (@button_down_xy && ((@button_down_xy[0] - e.x) ** 2 + (@button_down_xy[1] - e.y) ** 2 > 100))
          @drag = true
          report DragEvent.new e
        end
      end
          

      attr_accessor :parent, :action
      alias_method :a, :action

      attr :state, :body, :mouse_pad, :keyboard_pad, :button_pad, :pads

      def include? x, y
        sx = self.x
        sy = self.y
        x > sx && x < sx + @body.w && y > sy && y < sy + @body.h
      end

      def anc
        to_en{|e, b| par = e.parent; par == action ? b : par }
      end

      def sanc
        to_e{|e, b| par = e.parent; par == action ? b : par }
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
        xy = mouse.xy
        @button_down_xy = xy
        @drag = true
        report DragEvent.new(nil, *xy)
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
        index = next_pad && @paints[next_pad]&.index
        push_paint(pad, true, index).alter parent: self, action: action
        if index
          pad_index = ([index, @pads.size].min...0).step(-1).find do |i|
            @paints[@pads[i - 1]].index < index
          end || 0
          @pads.insert pad_index, pad
        else
          @pads << pad
        end
        pad.clip! body if clip
        event_director.stem do
          action.update_mouse_pad *mouse.position, false
        end if mousy? && mouse_in?
        pad
      end

      def remove_pad pad
        @pads.delete pad
        pad.composite! false
        event_director.stem do
          action.update_mouse_pad *mouse.position, false
        end if mousy? && mouse_in?
      end

      def attach! parent
        return if @parent == parent
        detach! if @parent
        @parent = parent
        @parent&.push_pad self
      end

      def detach!
        super
        @parent&.remove_pad self
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

      def event_director
        parent&.event_director
      end

      def sketch_base
        sketch self
        @sketched = true
        self
      end
      
      def set_size w, h
        body.wh!(w, h) && begin
          event_director.stem do
            report ResizeEvent.new
            action.update_mouse_pad *mouse.position if mousy? && show?
          end
          true
        end
      end
      
      def set_x x
        super && begin
          event_director.stem do
            action.update_mouse_pad *mouse.position if mousy? && show?
            report MoveEvent.new
          end if mousy? && sketched?
          true
        end
      end

      def set_y y
        super && begin
          event_director.stem do
            action.update_mouse_pad *mouse.position if mousy? && show?
            report MoveEvent.new
          end if mousy? && sketched?
          true
        end
      end

      def set_xy x, y
        super && begin
          event_director.stem do
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

      def point_pads x, y, hash = {}
        if mousy? && show? && include?(x, y)
          hash[self] = [x, y]
          x -= self.x
          y -= self.y
          @pads.reverse_each.find{ _1.point_pads x, y, hash }
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

      def gain_button
        action.button_pad = self
      end

      def lose_button
        action.button_pad = nil if action.button_pad == self
      end

      def set_button set
        set ? gain_button : lose_button
      end

      def translate x, y
        parent.translate x + self.x, y + self. y
      end

      def autosized?
        false
      end

      def report event, &block
        event.target = self
        ancs = anc.to_a
        ed = event_director
        ed.stem do
          ancs.reverse_each do |pad|
            ed.push event, pad, :aim
          end
          ed.push event, self, :alt
          ed.push_block event, block if block
          ancs.each do |pad|
            ed.push event, pad, :alt
          end
        end
      end

      def resolve event, mode = :default
        @event_manager.resolve event, mode
      end
    end
  end
end