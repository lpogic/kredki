require_relative 'pad_event_manager'
require_relative 'pad_events'
require_relative 'pad_base'
require_relative 'pad_inherited'
require 'forwardable'
require 'kredki-core/context/context'
require 'kredki-core/flagship'
require 'kredki-core/block_shape_area'
require_relative '../layout/layout'

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

      def <<(arg)
        case arg
        when Symbol
          name! arg
        when Pad
          arg.attach! self
        when Hash
          alter **arg
        when Array
          alter *arg
        when Proc
          alter &arg
        when Module
          if arg <= Layout
            layout! arg
          else
            use! arg
          end
        else
          raise "Unsupported << (#{arg} : #{arg.class})"
        end
        self
      end

      param def x! x
        return if eqr @x, x
        @x = x
        @x == :auto ? parent.arrange : set_xy
      end

      param def y! y
        return if eqr @y, y
        @y = y
        @y == :auto ? parent.arrange : set_xy
      end

      param def xy! x, y = nil
        y ||= x
        return if (eqr @y, y) && (eqr @x, x)
        @x = x
        @y = y
        @x == :auto || @y == :auto ? parent.arrange : set_xy
      end, get: def xy
        [@x, @y]
      end
          
      param def w! w
        return if eqr @w, w
        @w = w
        set_size
      end, :width

      param def h! h
        return if eqr @h, h
        @h = h
        set_size
      end, :height

      param def wh! w, h = nil
        h ||= w
        return if (eqr @w, w) && (eqr @h, h)
        @w = w
        @h = h
        set_size
      end, :size, get: def wh
        [@w, @h]
      end

      param def me! me
        return if eqr @me, me
        @me = me
        set_margin
      end, :margin_east

      param def mn! mn
        return if eqr @mn, mn
        @mn = mn
        set_margin
      end, :margin_north

      param def mw! mw
        return if eqr @mw, mw
        @mw = mw
        set_margin
      end, :margin_west

      param def ms! ms
        return if eqr @ms, ms
        @ms = ms
        set_margin
      end, :margin_south

      param def mx! me, mw = nil
        mw ||= me
        return if (eqr @me, me) && (eqr @mw, mw)
        @me = me
        @mw = mw
        set_margin
      end, :margin_x, get: def mx
        (eqr @me, @mw) ? @me : [@me, @mw]
      end

      param def my! mn, ms = nil
        ms ||= mn
        return if (eqr @mn, mn) && (eqr @ms, ms)
        @mn = mn
        @ms = ms
        set_margin
      end, :margin_y, get: def my
        (eqr @mn, @ms) ? @mn : [@mn, @ms]
      end

      param def m! me, mn = nil, mw = nil, ms = nil
        mn ||= me
        mw ||= me
        ms ||= mn
        return if (eqr @me, me) && (eqr @mw, mw) && (eqr @mn, mn) && (eqr @ms, ms)
        @me = me
        @mw = mw
        @mn = mn
        @ms = ms
        set_margin
      end, :margin, get: def m
        (eqr @me, @mw) && (eqr @mn, @ms) ? (eqr @me, @mn) ? @me : [@me, @mn] : [@me, @mw, @mn, @ms]
      end

      def sx
        @scene.x
      end

      def sy
        @scene.y
      end

      def sxy
        [sx, sy]
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

      def sw
        @area.w
      end

      def sh
        @area.h
      end
      
      def cw
        @clip_area.w
      end

      def ch
        @clip_area.h
      end

      def cwh
        @clip_area.wh
      end

      def pw fit = false
        mx = @me + @mw
        return mx + @layout.fit_w(self) if fit
        case @w
        when Rational
          mx
        when Proc
          mx
        when :fit
          mx + @layout.fit_w(self)
        else
          if @w < 0
            mx
          else
            @w + mx
          end
        end
      end

      def ph fit = false
        my = @mn + @ms
        return my + mx + @layout.fit_h(self) if fit
        case @h
        when Rational
          my
        when Proc
          my
        when :fit
          my + @layout.fit_h(self)
        else
          if @h < 0
            my
          else
            @h + my
          end
        end
      end

      param_prefix :stroke

      param_delegate :@area, 
        :blunt, 
        :stroke_width, 
        :stroke_color, 
        :stroke_join, 
        :stroke_cap
    
      param def color! *color
        case color
        in [false]
          area.hide!
        else
          area.show!
          area.color! *color
        end
      end, get: def color
        @area.color
      end

      param def area! area = nil, &block
        area = BlockShapeArea.new block if block
        return if @area == area
        area.wh! *@area.wh
        @scene.push_paint area, true, @area
        @scene.remove_paint @area
        @area = area
        true
      end

      param def clip_area! area = nil, &block
        area = BlockShapeArea.new block if block
        return if @clip_area == area
        area&.wh! *@clip_area.wh
        @clip_scene.clip! area
        @clip_area = area
        true
      end

      param def layout! layout, ...
        layout = layout.new.alter(...) if layout.is_a? Class
        return if @layout == layout
        @layout = layout
        arrange
        layer&.update_mouse_location if mousy? && show?
        true
      end

      param def name! name
        @names[name] = true
      end, get: def name
        @names.keys
      end

      def =~(filter)
        case filter
        when Symbol
          !!@names[filter]
        when Module, Proc
          filter === self
        else
          raise "Unsupported =~ (#{filter} : #{filter.class})"
        end
      end

      def lineage include_self = true
        Enumerator.new do |e|
          c = include_self ? self : parent
          while c && !c.is_a?(Action)
            e << c
            c = c.parent
          end
        end
      end

      def grand filter
        lineage.find{ _1 =~ filter }
      end

      def layer
        grand Layer
      end

      def in? grand
        lineage(false).include? grand
      end

      def include? child
        child.in? self
      end
     
      attr :parent, :action, :scene, :clip_area, :clip_scene, :pads

      alias_method :a, :action

      def s
        self
      end

      param def show! show = true
        set_show show
      end, get: def show
        get_show
      end

      def show?
        get_show
      end

      def include_point? x, y
        @area.contain? x, y
      end

      def mouse_in?
        layer&.mouse_pad&.lineage&.any?{ _1 == self } || false
      end

      def mouse_top?
        layer&.mouse_pad == self
      end

      def keyboard_in?
        layer&.keyboard_pad&.lineage&.any?{ _1 == self } || false
      end

      def keyboard_top?
        layer&.keyboard_pad == self
      end

      def button_in?
        layer&.button_pad&.lineage&.any?{ _1 == self } || false
      end

      def button_top?
        layer&.button_pad == self
      end

      def_flag :keyboardy
      def_flag :mousy, nil: true
      def_flag :focus, set: :set_focus, get: :keyboard_top?
      def_flag :pin, set: :set_button, get: :button_top?

      def drag! start_point = nil
        gain_button start_point
        @drag = true
        report DragEvent.new(start_point, nil, *action.mouse.xy)
      end

      def drag?
        !!@drag
      end

      def clear!
        clear_pads
      end

      def attach! parent
        return if @parent == parent
        raise "LOOP" if parent.lineage.find{ _1 == self }
        detach! true if @parent
        parent&.push_pad self
      end

      def detach! transfer = false
        @scene.detach!
        @parent&.remove_pad self, transfer
        @parent = nil
      end

      def roi!
        report ROIEvent.new *wh, *translate
      end

      def use! extension, *a, **na, &b
        extension.plug_into self, *a, **na, &b if extension.respond_to? :plug_into
      end

      #internal api

      def initialize
        super
        @action = nil
        @parent = nil
        @scene = Scene.new
        @area = @scene.rectangle!
        @clip_scene = @scene.scene!
        @clip_area = @clip_scene.rectangle!{ hide! }
        @names = {}
        @event_manager = PadEventManager.new
        @pads = []
        @button_down_xy = nil
        @x = @y = :auto
        @w = @h = 100
        @me = @mn = @mw = @ms = 0
        @layout = Layout::INSTANCE
      end

      def sketch p0
        @clip_scene.clip! @clip_area

        on_mouse_enter!{ mouse_enter _1 }
        on_mouse_leave!{ mouse_leave _1 }
        on_mouse_button!{ mouse_button_down _1 }
        on_mouse_button_up!{ mouse_button_up _1 }
        on_mouse_move!{ mouse_move _1 }
      end

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
        layer.update_mouse_location
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
          report DragEvent.new @button_down_xy, e.origin
        end
        e.resolve
      end

      def inspect
        "#{self.class}:#{object_id}"
      end

      aliasing def new_pad klass = Pad, *a, _at: nil, **na, &b
        pad = klass.new
        pad.alter_begin
        pad.sketch pad
        push_pad pad, _at
        pad.alter *a, **na, &b
        pad.alter_commit
        pad
      end, :put!

      def pad_index
        parent&.pads.index self
      end

      def push_pad pad, at = nil
        pad_parent = pad.parent
        paint_state = @clip_scene.push_paint pad.scene, true, at&.scene
        pad.set_parent self
        if at
          @pads.insert @pads.index(at), pad
        else
          @pads << pad
        end
        pad.set_size or arrange
        pad
      end

      def remove_pad pad, transfer
        removed = @pads.delete pad
        if removed && !transfer
          pad.scene.clip! false
          set_size or arrange
        end
        removed
      end

      def clear_pads
        pads, @pads = @pads, []
        pads.each do |pad|
          pad.detach! true
          pad.scene.clip! false
        end
        (set_size or arrange) unless pads.empty?
      end

      def eqr a, b
        a == b and (Rational === b) != (Rational === b)
      end

      def set_xy
        set_xy_s and event_director.stem{ layer&.update_mouse_location if mousy? && show? }
      end
      
      def set_xy_s ax = nil, ay = nil
        update_xy ax, ay and event_director.stem{ report MoveEvent.new }
      end

      def update_xy ax = nil, ay = nil
        sx = get_x ax
        sy = get_y ay

        @scene.xy! sx, sy
      end

      def get_x auto
        case @x
        when Rational
          sw = area.w
          pw = parent&.cw || 0
          r = (pw - sw) * @x.to_f
          @x.denominator == 1 ? r / 100 : r
        when Proc
          sw = area.w
          pw = parent&.cw || 0
          @x[pw, sw]
        when :auto
          auto || @scene.x
        else
          @x
        end
      end

      def get_y auto
        case @y
        when Rational
          sh = area.h
          ph = parent&.ch || 0
          r = (ph - sh) * @y.to_f
          @y.denominator == 1 ? r / 100 : r
        when Proc
          sh = area.h
          ph = parent&.ch || 0
          @y[ph, sh]
        when :auto
          auto || @scene.y
        else
          @y
        end
      end

      def set_size
        parent&.set_size_p or (
          set_size_d and (
            parent&.arrange
            event_director.stem{ layer&.update_mouse_location if mousy? && show? }
          )
        )
      end

      def set_size_p
        @w == :fit || @h == :fit and set_size
      end

      def set_size_d
        set_size_s and set_size_c and arrange
      end

      def set_size_s
        update_size and event_director.stem do
          report ResizeEvent.new
          update_xy and report MoveEvent.new
        end
      end

      def set_size_c
        @pads.each{ it.set_size_d }
        true
      end

      def update_size
        mx = @me + @mw
        my = @mn + @ms
        sw = get_w mx
        sh = get_h my

        (@area.wh! sw, sh) | (@clip_area.wh! sw - mx, sh - my)
      end

      def arrange
        return if alter_filter :arrange
        @layout.arrange self
      end

      def get_w mx
        case @w
        when Rational
          pw = parent&.cw || 0
          r = pw * @w.to_f
          @w.denominator == 1 ? r / 100 : r
        when Proc
          pw = parent&.cw || 0
          @w[pw]
        when :fit
          mx + @layout.fit_w(self)
        else
          if @w < 0
            pw = parent&.cw || 0
            pw + @w
          else
            @w
          end
        end
      end

      def get_h my
        case @h
        when Rational
          ph = parent&.ch || 0
          r = ph * @h.to_f
          @h.denominator == 1 ? r / 100 : r
        when Proc
          ph = parent&.ch || 0
          @h[ph]
        when :fit
          my + @layout.fit_h(self)
        else
          if @h < 0
            ph = parent&.ch || 0
            ph + @h
          else
            @h
          end
        end
      end

      def set_margin
        update_margin and event_director.stem{ layer&.update_mouse_location if mousy? && show? }
      end

      def update_margin
        (@clip_scene.xy! @me, @mn) | (@clip_area.wh! sw - @me - @mw, sh - @mn - @ms and arrange)
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

      def get_show
        @scene.show?
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
          @pads.reverse_each.find{ _1.point_pads x - _1.sx, y - _1.sy, pads }
          return true
        end
        return false
      end

      def gain_keyboard
        pad = keyboardy? ? self : each_pad(deep: true).find{ _1.keyboardy? }
        layer.update_keyboard_pad pad
      end

      def lose_keyboard
        layer.update_keyboard_pad nil if keyboard_in?
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
        case target
        when self
        when nil
          if pa = parent
            return pa.translate x + sx, y + sy, false
          end
        when false
          if pa = parent
            return pa.translate x + cx, y + cy, false
          end
        else
          xy = parent.translate x + cx, y + cy
          xy = target.translate -xy[0], -xy[1]
          return [-xy[0], -xy[1]]
        end
        return [x, y]
      end

      def report event, path = true, instant = false
        event.target ||= self
        ed = event_director
        if path
          ancs = lineage.to_a
          if event.is_a? PositionEvent
            x = y = 0
            ed.stem do
              ancs.reverse_each do |pad|
                cx = x
                cy = y
                ed.push_block event, instant do
                  event.x -= pad.sx + cx
                  event.y -= pad.sy + cy
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
        return if @parent == parent
        @parent = parent
        set_action parent&.action
      end

      def set_action action
        return if @action == action
        @action = action
        @pads.each{ _1.set_action action }
      end
    end
  end
end