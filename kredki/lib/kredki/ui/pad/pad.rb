require_relative 'service'
require_relative 'pad_event_manager'
require_relative 'pad_events'
require_relative 'pad_base'
require_relative 'pad_inherited'

module Kredki
  module UI
    class Pad < Service
      include PadBase
      include LocalMedia
      include PadEvents
      extend Forwardable
      extend HasParams
      extend PadInherited

      def <<(arg)
        case arg
        when Pad
          put! arg
        else
          super
        end
      end

      param def x! x = @x
        return x! yield @x if block_given?
        return if UI.eqr @x, x
        @x = x
        layer&.break_layout
        true
      end

      param def y! y = @y
        return y! yield @y if block_given?
        return if UI.eqr @y, y
        @y = y
        layer&.break_layout
        true
      end

      param def xy! x = nil, y = nil
        return xy! *Util.cover(yield self.xy) if block_given?
        if x
          y ||= x
        else
          x ||= @x
          y ||= @y
        end
        return if (UI.eqr @y, y) && (UI.eqr @x, x)
        @x = x
        @y = y
        layer&.break_layout
        true
      end, def xy
        [@x, @y]
      end
          
      param def w! *w
        return w! *Util.cover(yield @w) if block_given?
        w = Util.uncover w
        return if UI.eqr @w, w
        @w = w
        layer&.break_layout
        true
      end

      param def h! *h
        return h! *Util.cover(yield @h) if block_given?
        h = Util.uncover h
        return if UI.eqr @h, h
        @h = h
        layer&.break_layout
        true
      end

      param def wh! w = nil, h = nil
        return wh! *Util.cover(yield self.wh) if block_given?
        if w
          h ||= w
        else
          w ||= @w
          h ||= @h
        end
        return if (UI.eqr @w, w) && (UI.eqr @h, h)
        @w = w
        @h = h
        layer&.break_layout
        true
      end, def wh
        [@w, @h]
      end

      param def mxb! m = @mxb
        return mxb! yield @mxb if block_given?
        return if UI.eqr @mxb, m
        @mxb = m
        layer&.break_layout
        true
      end

      param def mxe! m = @mxe
        return mxe! yield @mxe if block_given?
        return if UI.eqr @mxe, m
        @mxe = m
        layer&.break_layout
        true
      end

      param def myb! m = @myb
        return myb! yield @myb if block_given?
        return if UI.eqr @myb, m
        @myb = m
        layer&.break_layout
        true
      end

      param def mye! m = @mye
        return mye! yield @mye if block_given?
        return if UI.eqr @mye, m
        @mye = m
        layer&.break_layout
        true
      end

      param def mx! mb = nil, me = nil
        return mx! *Util.cover(yield self.mx) if block_given?
        case m.size
        when 0 then return
        when 1
          mb = me = m[0]
        when 2
          mb = m[0]
          me = m[1]
        else
          raise_ia m
        end
        return if (UI.eqr @mxb, mb) && (UI.eqr @mxe, me)
        @mxb = mb
        @mxe = me
        layer&.break_layout
        true
      end, def mx
        [@mxb, @mxe]
      end

      param def my! mb = nil, me = nil
        return my! *Util.cover(yield self.my) if block_given?
        case m.size
        when 0 then return
        when 1
          mb = me = m[0]
        when 2
          mb = m[0]
          me = m[1]
        else
          raise_ia m
        end
        return if (UI.eqr @myb, mb) && (UI.eqr @mye, me)
        @myb = mb
        @mye = me
        layer&.break_layout
        true
      end, def my
        [@myb, @mye]
      end

      param def m! *m
        return m! *Util.cover(yield self.m) if block_given?
        case m.size
        when 0 then return
        when 1
          mxb = mxe = myb = mye = m[0]
        when 2
          mxb = mxe = m[0]
          myb = mye = m[1]
        when 3
          mxb = m[0]
          mxe = m[1]
          myb = mye = m[2]
        when 4
          mxb, mxe, myb, mye = *m
        else
          raise_ia m
        end
        return if (UI.eqr @mxb, mxb) && (UI.eqr @mxe, mxe) && (UI.eqr @myb, myb) && (UI.eqr @mye, mye)
        @mxb = mxb
        @mxe = mxe
        @myb = myb
        @mye = mye
        layer&.break_layout
        true
      end, def m
        [@mxb, @mxe, @myb, @mye]
      end

      param def mi! m
        return mi! yield @mi if block_given?
        return if UI.eqr @mi, m
        @mi = m
        layer&.break_layout
        true
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

      def sw
        @area.w
      end

      def sh
        @area.h
      end

      def swh
        @area.wh
      end

      def cx
        @clip_scene.x
      end

      def cy
        @clip_scene.y
      end

      def cxy
        [cx, cy]
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

      param def a! a = @a
        return a! yield @a if block_given?
        return if @a == a
        @a = a
        a *= Math::PI * 2 if a.is_a? Rational
        @scene.a! a
      end

      param_delegate :@scene, :d, :dx, :dy

      param def area! area = nil, &block
        if block
          if area
            area.alter &block
          else
            area = BlockShapeArea.new block
          end
        end
        return if @area == area
        area.keyword_safe_alter **@area
        area.attach! @scene, true, @area
        @area.detach!
        @area = area
        true
      end

      param def clip_area! area = nil, &block
        if block
          if area
            area.alter &block
          else
            area = BlockShapeArea.new block
          end
        end
        return if @clip_area == area
        area.keyword_safe_alter **@clip_area
        @clip_scene.clip! area
        @clip_area = area
        true
      end

      param def layout! layout = nil
        return layout! yield @layout if block_given?
        return if @layout == layout
        @layout = layout
        layout = UI.layout layout
        return true if @ui_layout == layout
        @ui_layout = layout
        layer&.break_layout
        true
      end

      attr :pad_parent, :clip_scene, :pads

      def scene &block
        @scene.alter &block if block
        @scene
      end

      def pad_lineage include_self = true
        Enumerator.new do |e|
          pad = include_self ? self : pad_parent
          while pad&.is_a?(Action)&.!
            e << pad
            pad = pad.pad_parent
          end
        end
      end

      def in_pad? pad
        pad_lineage.include? pad
      end

      def include_pad? pad
        pad.in_pad? self
      end

      flag def show! value = true
        return if (c = show) == (value = block_given? ? (yield c) : value == :not ? !c : value)
        set_show value
        true
      end, def show
        get_show
      end

      def hide!
        show! false
      end

      flag def layoutic! value = true
        return if (c = layoutic) == (value = block_given? ? (yield c) : value == :not ? !c : value)
        layer&.break_layout
        @layoutic = value
        true
      end, def layoutic
        @layoutic || @layoutic.nil?
      end

      flag def scenic! value = true
        return if (c = scenic) == (value = block_given? ? (yield c) : value == :not ? !c : value)
        set_scenic value
        true
      end, def scenic
        get_scenic
      end

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

      def key_down? key
        layer&.check_key_down key
      end

      def pin_in? button = nil
        layer&.check_pin self, button, false
      end

      def pin_top? button = nil
        layer&.check_pin self, button, true
      end

      flag def keyboardy! value = true
        return if (c = keyboardy) == (value = block_given? ? (yield c) : value == :not ? !c : value)
        @keyboardy = value
        true
      end
      
      flag def mousy! value = true
        return if (c = mousy) == (value = block_given? ? (yield c) : value == :not ? !c : value)
        @mousy = value
        true
      end, def mousy
        @mousy || @mousy.nil?
      end

      flag def focus! value = true
        return if (c = focus) == (value = block_given? ? (yield c) : value == :not ? !c : value)
        set_focus value
        true
      end, def focus
        keyboard_top?
      end
      
      flag def pin! value = true
        return if (c = pin) == (value = block_given? ? (yield c) : value == :not ? !c : value)
        set_pin value
        true
      end, def pin
        pin_top?
      end

      def drag! start_xy = nil, button = nil
        mouse_xy = action.mouse.xy
        pin_request start_xy || mouse_xy, button, true
        report MouseMoveEvent.new(:start, nil, *mouse_xy)
      end

      def clear!
        clear_pads
      end

      def put! pad, *a, at: nil, **na, &b
        pad.pad_detach
        pad.set_pad_parent self, at
        pad.alter(*a, **na, &b)
      end

      def attach! parent
        super
        parent&.grand(Pad)&.put_pad self
      end

      def detach! transfer = false
        super
        pad_detach transfer
      end

      def roi! x = 0, y = 0
        report ROIEvent.new *swh, x, y
      end

      def use! id
        plugin = Kredki.plugin id
        raise_ia id unless plugin
        alter &plugin
      end
      
      #internal api

      def initialize
        super
        @x = @y = :layout
        @w = @h = 100
        @a = 0
        @mxb = @mxe = @myb = @mye = 0
        @pad_parent = nil
        @scene = Scene.new
        initialize_area
        @clip_scene = @scene.scene!
        @clip_area = @clip_scene.rectangle! at: false, fill_color: false
        @pads = []
        @layout = nil
        @ui_layout = UI.layout
      end

      def initialize_area
        @area = @scene.rectangle! show: false
      end

      def pad_tree
        @pads.map{ [it, it.pad_tree] }.to_h
      end

      def sketch_pad
        sketch
        sketch_presence
        sketch_behavior
      end

      def sketch
      end

      def sketch_presence
        @clip_scene.clip! @clip_area
      end

      def sketch_behavior
        on_mouse_down! do: method(:mouse_down)
        on_mouse_up! do: method(:mouse_up)
        on_mouse_enter! do: method(:mouse_enter)
        on_mouse_leave! do: method(:mouse_leave)
        on_mouse_move! do: method(:mouse_move)
        on_focus_enter! do: method(:focus_enter)
        on_focus_leave! do: method(:focus_leave)
        on! KeyboardOfferEvent, do: method(:keyboard_offer)
      end

      def keyboard_offer e
        e.resolve if keyboardy? && keyboard_request
      end

      def mouse_enter e
      end

      def mouse_leave e
      end

      def mouse_move e
      end

      def mouse_down e
        report KeyboardOfferEvent.new if e.button_id == :primary
        pin_request e.xy, e.button_id
        e.resolve
      end

      def mouse_up e
        pin_dispose e.button_id
        if !e.drag && include_point?(*layer.translate(*e.xy, self))
          report MouseClickEvent.new e.origin
        end
        e.resolve
      end

      def focus_enter e
      end

      def focus_leave e
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
        case at
        when Integer
          paint_state = @clip_scene.put_paint pad.scene, true
          @pads.insert at, pad
        when Pad
          paint_state = @clip_scene.put_paint pad.scene, true, at.scene
          @pads.insert @pads.index(at), pad
        else
          paint_state = @clip_scene.put_paint pad.scene, true
          @pads << pad
        end
        layer&.break_layout
        pad
      end

      def remove_pad pad, transfer
        removed = @pads.delete pad
        if removed && !transfer
          layer&.break_layout
        end
        removed
      end

      def clear_pads
        pads, @pads = @pads, []
        pads.each do |pad|
          pad.detach! true
        end
        layer&.break_layout unless pads.empty?
      end

      def set_xy x, y
        @scene.xy! x, y
      end

      def get_x pcw, sw, ax
        case @x
        when Rational
          @x * pcw - sw * 0.5
        when Proc
          @x[pcw, sw]
        when Range
          ax + @x.begin
        when :e
          pcw - sw
        when :b
          0
        when :c
          (pcw - sw) * 0.5
        when :layout
          ax
        when Numeric
          @x
        else raise_is @x
        end
      end

      def get_y pch, sh, ay
        case @y
        when Rational
          @y * pch - sh * 0.5
        when Proc
          @y[pch, sh]
        when Range
          ay + @y.begin
        when :e
          pch - sh
        when :b
          0
        when :c
          (pch - sh) * 0.5
        when :layout
          ay
        when Numeric
          @y
        else raise_is @y
        end
      end

      def set_size w, h
        mx = @mxb + @mxe
        my = @myb + @mye
        @area.wh! w, h
        @scene.pxy! w * 0.5, h * 0.5
        @clip_area.wh! w - mx, h - my
      end

      def layout_pads
        pads.filter{ it.layoutic? }
      end

      def arrange_pads
        pads
      end

      def arrange
        @ui_layout.arrange self
      end

      def fit_w
        @mxb + @mxe + @ui_layout.fit_w(self)
      end

      def fit_h
        @myb + @mye + @ui_layout.fit_h(self)
      end

      def min_w
        m = @mxb + @mxe
        case @w
        when Rational, Proc
          m
        when :fit
          fit_w
        when :driven
          @area.w
        when Range
          b = case @w.begin
          when Rational
            m
          when Numeric
            @w.begin < 0 ? m : @w.begin
          when nil
            m
          else raise @w.begin
          end
          e = case @w.end
          when Rational
            m
          when Numeric
            @w.end < 0 ? m : @w.end
          when nil
            Float::INFINITY
          else raise @w.end
          end
          [b, e].min
        when Numeric
          @w < 0 ? m : @w
        else
          raise @w
        end
      end

      def min_h
        m = @myb + @mye
        case @h
        when Rational, Proc
          m
        when :fit
          fit_h
        when :driven
          @area.h
        when Range
          b = case @h.begin
          when Rational
            m
          when Numeric
            @h.begin < 0 ? m : @h.begin
          when nil
            m
          when :fit
            fit_h
          else raise_is @h.begin
          end
          e = case @h.end
          when Rational
            m
          when Numeric
            @h.end < 0 ? m : @h.end
          when nil
            Float::INFINITY
          when :fit
            fit_h
          else raise_is @h.end
          end
          [b, e].min
        when Numeric
          @h < 0 ? m : @h
        else
          raise @h
        end
      end

      def get_w
        case @w
        when Rational
          @pad_parent.get_w * @w
        when Proc
          @w[@pad_parent.get_w]
        when :fit
          fit_w
        when :driven
          @area.w
        when Range
          pcw = nil
          b = case @w.begin
          when Rational
            (pcw ||= @pad_parent.get_w) * @w.begin
          when Numeric
            @w.begin < 0 ? (pcw ||= @pad_parent.get_w) + @w.begin : @w.begin
          when nil
            0
          else raise @w.begin
          end
          e = case @w.end
          when Rational
            (pcw ||= @pad_parent.get_w) * @w.end
          when Numeric
            @w.end < 0 ? (pcw ||= @pad_parent.get_w) + @w.end : @w.end
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
          @w < 0 ? @pad_parent.get_w + @w : @w
        else
          raise @w
        end
      end

      def get_h
        case @h
        when Rational
          @pad_parent.get_h * @h
        when Proc
          @h[@pad_parent.get_h]
        when :fit
          fit_h
        when :driven
          @area.h
        when Range
          pch = nil
          b = case @h.begin
          when Rational
            (pch ||= @pad_parent.get_h) * @h.begin
            @h.begin.denominator == 1 ? r / 100 : r
          when Numeric
            @h.begin < 0 ? (pch ||= @pad_parent.get_h) + @h.begin : @h.begin
          when nil
            0
          else raise @h.begin
          end
          e = case @h.end
          when Rational
            (pch ||= @pad_parent.get_h) * @h.end
          when Numeric
            @h.end < 0 ? (pch ||= @pad_parent.get_h) + @h.end : @h.end
          when nil
            Float::INFINITY
          else raise @h.end
          end
          if @h.exclude_end?
            [b, e].min
          else
            [b, e].min
          end
        when Numeric
          @h < 0 ? @pad_parent.get_h + @h : @h
        else
          raise @h
        end
      end

      def set_margin
        x = @mxb
        y = @myb
        @clip_scene.xy! x, y
        @clip_area.xy! x, y
      end

      def set_scenic scenic
        @scene.set_show scenic
      end

      def get_scenic
        @scene.get_show true
      end

      def set_show show
        show_before = show?
        self.scenic = self.layoutic = show
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

      def get_show
        @scene.get_show false
      end

      def show_propagate
        if get_scenic
          report ShowEvent.new
          @pads.each &:show_propagate
        end
      end

      def hide_propagate
        if get_scenic
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

      def keyboard_request
        layer&.update_keyboard_pad self
      end

      def keyboard_dispose
        layer.update_keyboard_pad if keyboard_in?
      end

      def set_focus set
        set ? keyboard_request : keyboard_dispose
      end

      def pin_request xy = nil, button = nil, drag = false
        layer&.update_pin_pad self, xy, button, drag
      end

      def pin_dispose button = nil
        layer&.update_pin_pad nil if !button || button == layer&.pin_button
      end

      def set_pin set
        set ? pin_request : pin_dispose
      end

      def drag_check bxy, xy
        (bxy[0] - xy[0]) ** 2 + (bxy[1] - xy[1]) ** 2 > 100
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
            return pa.translate x + sx + cx, y + sy + cy, false
          end
        else
          xy = pad_parent.translate x + sx + cx, y + sy + cy
          xy = target.translate -xy[0], -xy[1]
          return [-xy[0], -xy[1]]
        end
        return [x, y]
      end

      def report event, path = true, instant = false
        event.target ||= self
        event_director = action&.event_director
        return unless event_director
        if path
          ancs = pad_lineage.to_a
          ancs.reverse_each do |pad|
            event_director.push event, pad, true, instant
          end
          ancs.each do |pad|
            event_director.push event, pad, false, instant
          end
        else
          event_director.push event, self, true, instant
          event_director.push event, self, false, instant
        end
      end

      def resolve event, aim = false
        @event_manager.resolve event, aim
      end

      def c_set_parent at
        return if @pad_parent
        set_pad_parent (@parent&.grand Pad), at
      end

      def set_pad_parent pad_parent, at
        @pad_parent = pad_parent
        @pad_parent&.put_pad self, at
      end
    end
  end
end