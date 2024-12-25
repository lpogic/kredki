require_relative 'pad_event_manager'
require_relative 'pad_events'
require_relative 'pad_base'
require_relative 'pad_inherited'
require 'forwardable'
require 'kredki-core/context/context'
require 'kredki-core/flagship'

module Kredki
  module UI
    class Pad
      include PadBase
      include Alterable
      include Context
      include PadEvents
      extend Forwardable
      extend Flagship
      extend PadInherited

      def initialize
        super
        @action = nil
        @parent = nil
        @scene = Scene.new
        @area = @scene.rectangle!
        @clip_scene = @scene.scene!
        @clip_area = @clip_scene.rectangle! do
          hide!
        end
        @names = {}
        @event_manager = PadEventManager.new
        @pads = []
        @button_down_xy = nil
        @x = @y = 0
        @w = @h = 100
        @me = @mn = @mw = @ms = 0
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
          if arg.start_with? "@"
            p0 = self
            a&.define_singleton_method arg[1..] do |&b|
              b ? p0.instance_eval(&b) : p0
            end
          end
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

      def_flag :keyboardy

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
        elsif include_point?(e.x, e.y) && e.button == :primary
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
      
      attr :parent, :action, :scene, :area, :pads, :clip_area, :clip_scene
      alias_method :a, :action

      def s
        self
      end

      def_delegators :@scene,
        :show?, :show!, :show=,
        :x, :y

      aliasing def area! area
        area.wh! *@area.wh
        @scene.push_paint area, true, @area
        @scene.remove_paint @area
        @area = area
      end, :area=

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

      def_flag :mousy, nil: true
      def_flag :focus, set: :set_focus, get: :keyboard_top?
      def_flag :mouse_focus, set: :set_button, get: :button_top?

      def drag! start_point = nil
        gain_button start_point
        @drag = true
        report DragEvent.new(nil, *action.mouse.xy)
      end

      def drag?
        !!@drag
      end

      aliasing def x! x
        eqr(@x, x) and set_xy x, @y
      end, :x=

      aliasing def y! y
        eqr(@y, y) and set_xy @x, y
      end, :y=

      def xy! x, y = nil
        y ||= x
        eqr(@x, x) || eqr(@y, y) and set_xy x, y
      end

      def xy= xy 
        case xy
        when Array
          xy! *xy
        else
          xy! xy
        end
      end

      aliasing def me! me
        eqr(@me, me) and set_margin me, @mn, @mw, @ms
      end, :me=, :margin_east!, :margin_east=

      aliasing def mn! mn
        eqr(@mn, mn) and set_margin @me, mn, @mw, @ms
      end, :mn=, :margin_north!, :margin_north=

      aliasing def mw! mw
        eqr(@mw, mw) and set_margin @me, @mn, mw, @ms
      end, :mw=, :margin_west!, :margin_west=

      aliasing def ms! ms
        eqr(@ms, ms) and set_margin @me, @ms, @mw, ms
      end, :ms=, :margin_south!, :margin_south=

      aliasing def mx! me, mw = nil
        mw ||= me
        eqr(@me, me) || eqr(@mw, mw) and set_margin me, @mn, mw, @ms
      end, :mx=, :margin_x!, :margin_x=

      aliasing def my! mn, ms = nil
        ms ||= mn
        eqr(@mn, mn) || eqr(@ms, ms) and set_margin @me, mn, @mw, ms
      end, :my=, :margin_y!, :margin_y=

      aliasing def m! me, mn = nil, mw = nil, ms = nil
        mn ||= me
        mw ||= me
        ms ||= mn
        eqr(@me, me) || eqr(@mw, mw) || eqr(@mn, mn) || eqr(@ms, ms) and set_margin me, mn, mw, ms
      end, :margin

      def m= m
        case m
        when Array
          m! *m
        else
          m! m
        end
      end

      def me
        @me
      end

      def mn
        @mn
      end

      def mw
        @mw
      end

      def ms
        @ms
      end

      def eqr a, b
        a != b || (Rational === a) != (Rational === b)
      end

      aliasing def w! w
        eqr @w, w and set_size w, @h
      end, :w=, :width!, :width=

      aliasing def h! h
        eqr @h, h and set_size @w, h
      end, :h=, :height!, :height=

      aliasing def wh! w, h = nil
        h ||= w
        eqr(@w, w) || eqr(@h, h) and set_size w, h
      end, :size!

      aliasing def wh=(wh)
        case wh
        when Array
          wh! *wh
        else
          wh! wh
        end
      end, :size=

      def cw
        @clip_area.w
      end

      def ch
        @clip_area.h
      end

      def cwh
        @clip_area.wh
      end

      def cx
        @scene.x + @clip_scene.x
      end

      def cy
        @scene.y + @clip_scene.y
      end

      def cxy
        [cx, cy]
      end

      def new_pad klass = Pad, *a, _at: nil, **na, &b
        pad = klass.new
        push_pad(pad.sketch_base, _at)
        pad.alter(*a, **na, &b).alter_commit
        pad
      end

      def pad_index
        parent&.pads.index self
      end

      def push_pad pad, at = nil, clip = true
        pad_parent = pad.parent
        paint_state = @clip_scene.push_paint pad.scene, true, at&.scene
        pad.set_parent self
        if at
          @pads.insert @pads.index(at), pad
        else
          @pads << pad
        end
        if clip
          pad.scene.clip! @clip_area
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
        parent&.push_pad self
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

      def roi!
        report ROIEvent.new *wh, *translate
      end

      def_delegators :@area,
        :h, :height, 
        :w, :width,
        :wh, :size,
        :color,
        :blunt!, :blunt=,
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
        @w = w
        @h = h
        update_size true
      end

      def update_size mouse_pad = false
        set_size_impl and event_director.stem do
          report ResizeEvent.new
          update_xy and report MoveEvent.new
          layer&.update_mouse_pad if mouse_pad && sketched? && mousy? && show?
          true
        end
      end

      def set_xy x, y
        @x = x
        @y = y
        update_xy and event_director.stem do
          report MoveEvent.new
          layer&.update_mouse_pad if sketched? && mousy? && show?
          true
        end
      end

      def set_margin e, n, w, s
        @me = e
        @mn = n
        @mw = w
        @ms = s
        update_margin and event_director.stem do
          layer&.update_mouse_pad if sketched? && mousy? && show?
          true
        end
      end

      def set_size_impl
        mx = @me + @mw
        my = @mn + @ms

        sw = case @w
        when Rational
          pw = parent&.cw || 0
          r = pw * @w.to_f
          @w.denominator == 1 ? r / 100 : r
        when Proc
          pw = parent&.cw || 0
          @w[pw]
        else
          if @w < 0
            pw = parent&.cw || 0
            pw + @w
          else
            @w
          end
        end
        
        sh = case @h
        when Rational
          ph = parent&.ch || 0
          r = ph * @h.to_f
          @h.denominator == 1 ? r / 100 : r
        when Proc
          ph = parent&.ch || 0
          @h[ph]
        else
          if @h < 0
            ph = parent&.ch || 0
            ph + @h
          else
            @h
          end
        end

        ((area.wh! sw, sh) | (@clip_area.wh! sw - mx, sh - my)) and propagate_resize
      end

      def update_xy
        sw = area.w
        sh = area.h
        pw = parent&.cw || 0
        ph = parent&.ch || 0

        sx = case @x
        when Rational 
          r = (pw - sw) * @x.to_f
          @x.denominator == 1 ? r / 100 : r
        when Proc
          @x[pw, sw]
        else
          @x
        end

        sy = case @y
        when Rational 
          r = (ph - sh) * @y.to_f
          @y.denominator == 1 ? r / 100 : r
        when Proc
          @y[ph, sh]
        else
          @y
        end

        @scene.xy! sx, sy
      end

      def update_margin
        (@clip_scene.xy! @me, @mn) | (@clip_area.wh! w - @me - @mw, h - @mn - @ms and propagate_resize)
      end

      def propagate_resize
        @pads.each(&:parent_resize)
        true
      end

      def parent_resize
        set_size_impl
        update_xy
      end

      def pref_min_w
        @me + @mw + (@pads.first&.pref_min_w || 0)
      end

      def pref_min_h
        @mn + @ms + (@pads.first&.pref_min_h || 0)
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
          x -= @clip_scene.x
          y -= @clip_scene.y
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
            return pa.translate x + self.x, y + self.y
          else 
            return [x, y] 
          end
        else
          xy = parent.translate x + self.cx, y + self.cy
          xy = target.translate -xy[0], -xy[1]
          return [-xy[0], -xy[1]]
        end
      end

      def autosized?
        false
      end

      def report event, path = true, instant = false
        event.target ||= self
        ed = event_director
        if path
          ancs = sanc.to_a
          if event.is_a? PositionEvent
            x = y = 0
            ed.stem do
              ancs.reverse_each do |pad|
                cx = x
                cy = y
                ed.push_block event, instant do
                  event.x -= pad.x + cx
                  event.y -= pad.y + cy
                end
                x, y = *pad.clip_scene.xy
                ed.push event, pad, true, instant
              end
              ancs.each do |pad|
                ed.push event, pad, false, instant
                ed.push_block event, instant do
                  event.x += pad.cx
                  event.y += pad.cy
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
        parent_resize
      end

      def set_action action
        @action = action
        @pads.each{ _1.set_action action }
      end
    end
  end
end