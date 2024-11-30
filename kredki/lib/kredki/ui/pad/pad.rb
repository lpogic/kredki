require_relative 'pad_event_manager'
require_relative 'pad_events'
require_relative 'pad_base'
require_relative 'pad_inherited'
require 'forwardable'
require 'kredki-core/context/context'
require 'kredki-core/has_flags'

module Kredki
  module UI
    class Pad
      include PadBase
      include Alterable
      include Context
      include PadEvents
      extend Forwardable
      extend HasFlags
      extend PadInherited

      def initialize
        super
        @action = nil
        @parent = nil
        @scene = Scene.new
        @area = @scene.rectangle!
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
        on_resize!{ resize _1 }
        on! SizeModeEvent do |e|
          size_mode e
        end
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
        self
      end

      def =~(filter)
        case filter
        when Symbol
          !!@names[filter]
        when Module
          filter === self
        when Proc
          filter.call self
        else
          raise "Unsupported =~ (#{filter} : #{filter.class})"
        end
      end

      def names
        @names
      end

      aliasing def n! name
        self << name
      end, :n=, :name!, :name=

      def_flag :keyboardy, true

      def mouse_button_down e
        if e.button == :primary
          gain_keyboard if keyboardy?
          gain_button e.xy
          e.resolve
        end
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
        elsif include_point?(e.x, e.y) && p(e.button) == :primary
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

      def resize e
        e.resolve if e.target != self
      end

      def size_mode e
        e.resolve if e.target != self
      end
      
      attr :parent, :action, :scene, :area, :pads
      alias_method :a, :action

      def s
        self
      end

      def_delegators :@scene,
        :show?, :show!, :show=

      def include_point? x, y
        x >= 0 && y >= 0 && x <= @area.w && y <= @area.h
      end

      def anc
        to_en{|e, b| e.parent&.then{ _1 unless _1.is_a? Action } || b }
      end

      def sanc
        to_e{|e, b| e.parent&.then{ _1 unless _1.is_a? Action } || b }
      end

      def grand filter
        sanc.find{ _1 =~ filter }
      end

      def layer
        grand Layer
      end

      def included? parent
        anc.include? parent
      end

      def include? child
        child.included? self
      end

      def mouse_in?
        layer&.mouse_pad&.sanc&.any?{ _1 == self } || false
      end

      def mouse_top?
        layer&.mouse_pad == self
      end

      def keyboard_in?
        layer&.keyboard_pad&.sanc&.any?{ _1 == self } || false
      end

      def keyboard_top?
        layer&.keyboard_pad == self
      end

      def button_in?
        layer&.button_pad&.sanc&.any?{ _1 == self } || false
      end

      def button_top?
        layer&.button_pad == self
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
        set_x(x) && move_common
      end, :x=

      aliasing def y! y
        set_y(y) && move_common
      end, :y=

      def xy! x, y
        set_xy(x, y) && move_common
      end

      def xy=(xy)
        xy! *xy
      end

      def x
        @scene.x
      end

      def y
        @scene.y
      end

      def xy
        @scene.xy
      end

      aliasing def w! w = nil
        set_size(w, h) && resize_common
      end, :w=, :width!, :width=

      aliasing def h! h = nil
        set_size(w, h) && resize_common
      end, :h=, :height!, :height=

      aliasing def wh! w, h = nil
        set_size(w, h || w) && resize_common
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
        pad = klass.new
        push_pad(pad.sketch_base, _index)
        pad.alter(*a, **na, &b).alter_commit
        pad
      end

      def pad_index
        parent&.paint_index self
      end

      def push_pad pad, paint_index = nil, clip = true
        pad_parent = pad.parent
        paint_state = @scene.push_paint pad.scene, true, paint_index
        pad.set_parent self
        if paint_index
          start = [paint_state.index, @pads.size - 1].min
          paints = @scene.paint_hash
          pad_index = (start..0).step(-1).find do |i|
            paints[@pads[i].scene].index < paint_state.index
          end || -1
          @pads.insert pad_index + 1, pad
        else
          @pads << pad
        end
        if clip
          pad.scene.clip! area
        elsif pad_parent
          pad.scene.clip! nil
        end
        report ContentChangeEvent.new
        event_director.stem do
          layer.update_mouse_pad
        end if mousy? && mouse_in? || pad.mousy? && pad.mouse_in?
        pad
      end

      def remove_pad pad, transfer
        removed = @pads.delete pad
        if removed && !transfer
          pad.scene.clip! false
          report ContentChangeEvent.new
          event_director.stem do
            layer.update_mouse_pad
          end if mousy? && mouse_in?
        end
        removed
      end

      def clear_pads
        pads, @pads = @pads, []
        pads.each do |pad|
          pad.detach! true
          pad.scene.clip! false
        end
        unless pads.empty?
          report ContentChangeEvent.new
          event_director.stem do
            layer.update_mouse_pad
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
        @scene.detach!
        @parent&.remove_pad self, transfer
        @parent = nil
      end

      def use! extension, *a, **na, &b
        extension.plug_into self, *a, **na, &b if extension.respond_to? :plug_into
      end

      
      def color! *color, &block
        case color
        in [false]
          area.hide!
        else
          area.show!
          area.color! *color, &block
        end
      end

      def color= color
        if color.is_a? Array
          color! *color
        else
          color! color
        end
      end

      def_delegators :@area,
        :h, :height, 
        :w, :width,
        :wh, :size,
        :color,
        :r!, :r=, :radius!, :radius=,
        :stroke_width!, :stroke_width=, :stroke_color!, :stroke_color=

      #internal api

      def inspect
        "#{self.class}:#{object_id}"
      end

      def sketch_base
        alter_begin
        sketch self unless @sketched
        @sketched = true
        self
      end
      
      def set_size w, h
        area.wh! w, h
      end
      
      def set_x x
        @scene.set_x x
      end

      def set_y y
        @scene.set_y y
      end

      def set_xy x, y
        @scene.set_xy x, y
      end

      def max_x
        x + w
      end

      def max_y
        y + h
      end

      def move_common
        event_director.stem do
          layer.update_mouse_pad if mousy? && show?
          report MoveEvent.new
        end if sketched?
        true
      end

      def resize_common
        event_director.stem do
          report ResizeEvent.new
          layer.update_mouse_pad if mousy? && show?
        end
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
        @scene.set_show show
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
        if force || (mousy? && show? && include_point?(x, y))
          pads << self
          @pads.reverse_each.find{ _1.point_pads x - _1.x, y - _1.y, pads }
          return true
        end
        return false
      end

      def gain_keyboard
        pad = keyboardy? ? self : each_pad(deep_first: true).find{ _1.keyboardy? }
        layer.update_keyboard_pad pad
      end

      def lose_keyboard
        layer.update_keyboard_pad nil if keyboard_in?
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
        layer.update_button_pad self, self
      end

      def lose_button
        @button_down_xy = nil
        layer.update_button_pad self, nil
      end

      def set_button set
        set ? gain_button : lose_button
      end

      def translate x = 0, y = 0, target = nil
        if target == self
          return [x, y]
        elsif target == nil
          if pa = parent
            return parent.translate x + self.x, y + self.y
          else 
            return [x, y] 
          end
        else
          xy = parent.translate x + self.x, y + self.y
          xy = target.translate -xy[0], -xy[1]
          return [-xy[0], -xy[1]]
        end
      end

      def autosized?
        false
      end

      def update_child_xy_on_resize?
        false
      end

      def report event, path = true, instant = false
        event.target = self
        ed = event_director
        if path
          ancs = sanc.to_a
          if event.is_a? PositionEvent
            ed.stem do
              ancs.reverse_each do |pad|
                ed.push_block event, instant do
                  event.x -= pad.x
                  event.y -= pad.y
                end
                ed.push event, pad, true, instant
              end
              ancs.each do |pad|
                ed.push event, pad, false, instant
                ed.push_block event, instant do
                  event.x += pad.x
                  event.y += pad.y
                end
              end
            end
          else
            ed.stem do
              ancs.reverse_each do |pad|
                ed.push event, pad, true, instant
              end
              ancs.each do |pad|
                ed.push event, pad, false, instant
              end
            end
          end
        else
          ed.push event, self, true, instant
          ed.push event, self, false, instant
        end
      end

      def resolve event, aim = false
        @event_manager.resolve event, aim
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