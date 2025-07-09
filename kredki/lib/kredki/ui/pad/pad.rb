require_relative 'service'
require_relative 'pad_event_manager'
require_relative 'pad_events'
require_relative 'pad_base'
require_relative 'pad_inherited'
require 'forwardable'
require 'kredki-core/context/context'
require 'kredki-core/flagship'
require 'kredki-core/block_shape_area'

module Kredki
  module UI
    class Pad < Service
      include PadBase
      include Alterable
      include Context
      include PadEvents
      extend Forwardable
      extend Flagship
      extend PadInherited

      def <<(arg)
        case arg
        when Pad
          arg.attach! self
        else
          super
        end
      end

      param def x! x
        return if UI.eqr @x, x
        @x = x
        layer&.break_layout
        true
      end

      param def y! y
        return if UI.eqr @y, y
        @y = y
        layer&.break_layout
        true
      end

      param def xy! x, y = nil
        y ||= x
        return if (UI.eqr @y, y) && (UI.eqr @x, x)
        @x = x
        @y = y
        layer&.break_layout
        true
      end, get: def xy
        [@x, @y]
      end
          
      param def w! w
        return if UI.eqr @w, w
        @w = w
        layer&.break_layout
        true
      end, :width

      param def h! h
        return if UI.eqr @h, h
        @h = h
        layer&.break_layout
        true
      end, :height

      param def wh! w, h = nil
        h ||= w
        return if (UI.eqr @w, w) && (UI.eqr @h, h)
        @w = w
        @h = h
        layer&.break_layout
        true
      end, :size, get: def wh
        [@w, @h]
      end

      param def me! me
        return if UI.eqr @me, me
        @me = me
        layer&.break_layout
        true
      end, :margin_east

      param def mn! mn
        return if UI.eqr @mn, mn
        @mn = mn
        layer&.break_layout
        true
      end, :margin_north

      param def mw! mw
        return if UI.eqr @mw, mw
        @mw = mw
        layer&.break_layout
        true
      end, :margin_west

      param def ms! ms
        return if UI.eqr @ms, ms
        @ms = ms
        layer&.break_layout
        true
      end, :margin_south

      param def mx! me, mw = nil
        mw ||= me
        return if (UI.eqr @me, me) && (UI.eqr @mw, mw)
        @me = me
        @mw = mw
        layer&.break_layout
        true
      end, :margin_x, get: def mx
        (UI.eqr @me, @mw) ? @me : [@me, @mw]
      end

      param def my! mn, ms = nil
        ms ||= mn
        return if (UI.eqr @mn, mn) && (UI.eqr @ms, ms)
        @mn = mn
        @ms = ms
        layer&.break_layout
        true
      end, :margin_y, get: def my
        (UI.eqr @mn, @ms) ? @mn : [@mn, @ms]
      end

      param def m! me, mn = nil, mw = nil, ms = nil
        mn ||= me
        mw ||= me
        ms ||= mn
        return if (UI.eqr @me, me) && (UI.eqr @mw, mw) && (UI.eqr @mn, mn) && (UI.eqr @ms, ms)
        @me = me
        @mw = mw
        @mn = mn
        @ms = ms
        layer&.break_layout
        true
      end, :margin, get: def m
        (UI.eqr @me, @mw) && (UI.eqr @mn, @ms) ? (UI.eqr @me, @mn) ? @me : [@me, @mn] : [@me, @mw, @mn, @ms]
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

      def swh
        @area.wh
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

      param_prefix :stroke

      param def stroke_width! width
        return if @stroke_width == width
        @stroke_width = width
        @area.stroke_width = width
        layer&.break_layout
        true
      end

      param_delegate :@area, 
        :stroke_color, 
        :stroke_join, 
        :stroke_cap,
        :color

      param def blunt! blunt, clip = true
        @area.blunt! blunt
        @clip_area.blunt! blunt if clip
      end, get: def blunt
        @area.blunt
      end

      param def area! area = nil, &block
        area = BlockShapeArea.new block if block
        return if @area == area
        area.safe_alter **@area
        @scene.put_paint area, true, @area
        @scene.remove_paint @area
        @area = area
        true
      end

      param def clip_area! area = nil, &block
        area = BlockShapeArea.new block if block
        return if @clip_area == area
        area.safe_alter **@clip_area
        @clip_scene.clip! area
        @clip_area = area
        true
      end

      param def layout! *layout
        layout = layout.size > 1 ? layout : layout.first
        return if @layout == layout
        @_layout = UI.layout layout
        @layout = layout
        layer&.break_layout
        true
      end

      attr :pad_parent, :scene, :clip_area, :clip_scene, :pads

      def pad_lineage include_self = true
        Enumerator.new do |e|
          c = include_self ? self : pad_parent
          while c && !c.is_a?(Action)
            e << c
            c = c.pad_parent
          end
        end
      end

      def_flag :show, set: :set_show, get: :get_show, test: false

      def show? direct = false
        get_show direct
      end

      def hide!
        show! false
      end

      def_flag :in_layout, nil: true, set: :set_in_layout

      def include_point? x, y
        @area.contain? x, y
      end

      def mouse_in?
        layer&.mouse_pad&.pad_lineage&.any?{ _1 == self } || false
      end

      def mouse_top?
        layer&.mouse_pad == self
      end

      def keyboard_in?
        layer&.keyboard_pad&.pad_lineage&.any?{ _1 == self } || false
      end

      def keyboard_top?
        layer&.keyboard_pad == self
      end

      def button_in?
        layer&.button_pad&.pad_lineage&.any?{ _1 == self } || false
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
        super
        parent&.grand(Pad)&.put_pad self
      end

      def detach! transfer = false
        super
        pad_detach transfer
      end

      def roi!
        report ROIEvent.new *swh, *translate
      end

      def use! extension, *a, **na, &b
        extension.plug_into self, *a, **na, &b if extension.respond_to? :plug_into
      end

      #internal api

      def initialize
        super
        @pad_parent = nil
        @scene = Scene.new
        @area = @scene.rectangle!
        @clip_scene = @scene.scene!
        @clip_area = @clip_scene.rectangle!
        @event_manager = PadEventManager.new
        @pads = []
        @button_down_xy = nil
        @x = @y = :auto
        @w = @h = 100
        @me = @mn = @mw = @ms = 0
        @stroke_width = 0
        @layout = nil
        @_layout = UI.layout
      end

      def pad_tree
        @pads.map{ [it, it.pad_tree] }.to_h
      end

      def sketch p0
        @clip_scene.clip! @clip_area

        on_mouse_enter!{ mouse_enter _1 }
        on_mouse_leave!{ mouse_leave _1 }
        on_mouse_button!{ mouse_button_down _1 }
        on_mouse_button_up!{ mouse_button_up _1 }
        on_mouse_move!{ mouse_move _1 }
        on_focus_gain!{ focus_gain _1 }
        on_focus_lose!{ focus_lose _1 }
      end

      def mouse_button_down e
        if e.button == :primary
          gain_keyboard if keyboardy?
          gain_button e.xy
          e.resolve
        end
      end

      def mouse_enter e
        # e.resolve
      end

      def mouse_leave e
        # e.resolve
      end

      def mouse_button_up e
        lose_button
        if @drag
          @drag = false
          report DropEvent.new e.origin
        elsif include_point?(e.x, e.y) && e.button == :primary
          report ClickEvent.new e.origin
        end
        e.resolve
      end

      def mouse_move e
        if @drag || (@button_down_xy && ((@button_down_xy[0] - e.x) ** 2 + (@button_down_xy[1] - e.y) ** 2 > 100))
          @drag = true
          report DragEvent.new @button_down_xy, e.origin
        end
        # e.resolve
      end

      def focus_gain e
        e.resolve
      end

      def focus_lose e
        e.resolve
      end

      def pad_detach transfer = false
        @scene.detach!
        if @pad_parent
          @pad_parent.remove_pad self, transfer
          @pad_parent = nil
          grand_pad_detach
        end
      end

      def pad_index
        pad_parent&.pads.index self
      end

      def put_pad pad, at = nil
        paint_state = @clip_scene.put_paint pad.scene, true, at&.scene
        case at
        when Integer
          @pads.insert at, pad
        when Pad
          @pads.insert @pads.index(at), pad
        else
          @pads << pad
        end
        layer&.break_layout
        pad
      end

      def remove_pad pad, transfer
        removed = @pads.delete pad
        if removed && !transfer
          pad.scene.clip! false
          layer&.break_layout
        end
        removed
      end

      def clear_pads
        pads, @pads = @pads, []
        pads.each do |pad|
          pad.detach! true
          pad.scene.clip! false
        end
        layer&.break_layout unless pads.empty?
      end

      def set_xy x, y
        @scene.xy! x, y
      end

      def get_x pcw, sw, ax
        case @x
        when Rational
          r = (pcw - sw) * @x.to_f
          @x.denominator == 1 ? r / 100 : r
        when Proc
          @x[pcw, sw]
        when Range
          ax + @x.begin
        when :auto
          ax
        else
          @x
        end
      end

      def get_y pch, sh, ay
        case @y
        when Rational
          r = (pch - sh) * @y.to_f
          @y.denominator == 1 ? r / 100 : r
        when Proc
          @y[pch, sh]
        when Range
          ay + @y.begin
        when :auto
          ay
        else
          @y
        end
      end

      def set_size w, h
        mx = @me + @mw
        my = @mn + @ms
        sw = @stroke_width * 2

        @area.wh! w, h
        @clip_area.wh! w - mx - sw, h - my - sw
      end

      def layout_pads
        pads.filter{ it.in_layout? }
      end

      def arrange_pads
        pads
      end

      def auto_x?
        @x == :auto
      end

      def auto_y?
        @y == :auto
      end

      def arrange
        @_layout.arrange self
      end

      def fit_w
        @me + @mw + @stroke_width * 2 + @_layout.fit_w(self)
      end

      def fit_h
        @mn + @ms + @stroke_width * 2 + @_layout.fit_h(self)
      end

      def min_w
        mw = @me + @mw + @stroke_width * 2
        case @w
        when Rational, Proc
          mw
        when :fit
          fit_w
        when Range
          b = case @w.begin
          when Rational
            mw
          when Numeric
            @w.begin < 0 ? mw : @w.begin
          when nil
            mw
          else raise @w.begin
          end
          e = case @w.end
          when Rational
            mw
          when Numeric
            @w.end < 0 ? mw : @w.end
          when nil
            Float::INFINITY
          else raise @w.end
          end
          [b, e].min
        when Numeric
          @w < 0 ? mw : @w
        else
          raise @w
        end
      end

      def min_h
        mh = @mn + @ms + @stroke_width * 2
        case @h
        when Rational, Proc
          mh
        when :fit
          fit_h
        when Range
          mh # todo
        when Numeric
          @h < 0 ? mh : @h
        else
          raise @h
        end
      end

      def get_w pcw
        case @w
        when Rational
          r = pcw * @w.to_f
          @w.denominator == 1 ? r / 100 : r
        when Proc
          @w[pcw]
        when :fit
          fit_w
        when Range
          b = case @w.begin
          when Rational
            r = pcw * @w.begin.to_f
            @w.begin.denominator == 1 ? r / 100 : r
          when Numeric
            @w.begin < 0 ? pcw + @w.begin : @w.begin
          when nil
            0
          else raise @w.begin
          end
          e = case @w.end
          when Rational
            r = pcw * @w.end.to_f
            @w.end.denominator == 1 ? r / 100 : r
          when Numeric
            @w.end < 0 ? pcw + @w.end : @w.end
          when nil
            Float::INFINITY
          else raise @w.end
          end
          if @w.exclude_end?
            [b, e].min
          else
            [b, e].min
          end
        when Numeric
          @w < 0 ? pcw + @w : @w
        else
          raise @w
        end
      end

      def get_h pch
        case @h
        when Rational
          r = pch * @h.to_f
          @h.denominator == 1 ? r / 100 : r
        when Proc
          @h[pch]
        when :fit
          fit_h
        when Range
          if @h.exclude_end?
            b = @h.end ? [pch, @h.end].min : pch
            [b, @h.begin || 0].max
          else
            b = [pch, @h.begin || 0].max
            @h.end ? [b, @h.end].min : b
          end
        when Numeric
          @h < 0 ? pch + @h : @h
        else
          raise @h
        end
      end

      def set_margin
        x = @me + @stroke_width
        y = @mn + @stroke_width
        @clip_scene.xy! x, y
        @clip_area.xy! x, y
      end

      def set_in_layout in_layout
        @in_layout = in_layout
        layer&.break_layout
        true
      end

      def set_show show
        show_before = show?
        @scene.set_show show
        show_after = show?
        if show_before != show_after
          if show_after
            report ShowEvent.new
            @pads.each &:show_propagate
          else
            report HideEvent.new
            @pads.each &:hide_propagate
          end
        end
      end

      def get_show direct = true
        @scene.show? direct
      end

      def show_propagate
        if show? true
          report ShowEvent.new
          @pads.each &:show_propagate
        end
      end

      def hide_propagate
        if show? true
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
          if pa = pad_parent
            return pa.translate x + sx, y + sy, false
          end
        when false
          if pa = pad_parent
            return pa.translate x + cx, y + cy, false
          end
        else
          xy = pad_parent.translate x + cx, y + cy
          xy = target.translate -xy[0], -xy[1]
          return [-xy[0], -xy[1]]
        end
        return [x, y]
      end

      def report event, path = true, instant = false
        event.target ||= self
        ed = event_director
        if path
          if event.is_a? PositionEvent
            ancs = pad_lineage.to_a
            ed.stem do
              x = y = 0
              ancs.reverse_each do |pad|
                cx = x
                cy = y
                ed.push_block event, instant do
                  event.x -= pad.sx + cx
                  event.y -= pad.sy + cy
                end
                ed.push event, pad, true, instant
                x, y = *pad.clip_scene.xy
              end
              x = -x
              y = -y
              ancs.each do |pad|
                cx = x
                cy = y
                ed.push_block event, instant do
                  event.x += pad.clip_scene.x + cx
                  event.y += pad.clip_scene.y + cy
                end
                ed.push event, pad, false, instant
                x, y = *pad.sxy
              end
            end
          else
            ancs = lineage.to_a
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

      def c_set_parent
        pad_parent = @parent&.grand Pad
        return if pad_parent == @pad_parent
        @pad_parent = pad_parent
        @pad_parent&.put_pad self
      end
    end
  end
end