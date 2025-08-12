require_relative 'service'
require_relative 'pad_event_manager'
require_relative 'pad_events'
require_relative 'pad_base'
require_relative 'pad_inherited'

module Kredki
  module UI
    class Pad < Service
      include PadBase
      include Alterable
      include LocalMedia
      include PadEvents
      extend Forwardable
      extend HasParams
      extend HasFlags
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
      end, def xy
        [@x, @y]
      end
          
      param def w! w
        return if UI.eqr @w, w
        @w = w
        layer&.break_layout
        true
      end

      param def h! h
        return if UI.eqr @h, h
        @h = h
        layer&.break_layout
        true
      end

      param def wh! w, h = nil
        h ||= w
        return if (UI.eqr @w, w) && (UI.eqr @h, h)
        @w = w
        @h = h
        layer&.break_layout
        true
      end, def wh
        [@w, @h]
      end

      param def mxb! m
        return if UI.eqr @mxb, m
        @mxb = m
        layer&.break_layout
        true
      end

      param def mxe! m
        return if UI.eqr @mxe, m
        @mxe = m
        layer&.break_layout
        true
      end

      param def myb! m
        return if UI.eqr @myb, m
        @myb = m
        layer&.break_layout
        true
      end

      param def mye! m
        return if UI.eqr @mye, m
        @mye = m
        layer&.break_layout
        true
      end

      param def mx! mb, me = nil
        me ||= mb
        return if (UI.eqr @mxb, mb) && (UI.eqr @mxe, me)
        @mxb = mb
        @mxe = me
        layer&.break_layout
        true
      end, def mx
        (UI.eqr @mxb, @mxe) ? @mb : [@mxb, @mxe]
      end

      param def my! mb, me = nil
        me ||= mb
        return if (UI.eqr @myb, mb) && (UI.eqr @mye, me)
        @myb = mb
        @mye = me
        layer&.break_layout
        true
      end, def my
        (UI.eqr @myb, @mye) ? @myb : [@myb, @mye]
      end

      param def m! mxb, mxe = nil, myb = nil, mye = nil
        mxe ||= mxb
        myb ||= mxb
        mye ||= myb
        return if (UI.eqr @mxb, mxb) && (UI.eqr @mxe, mxe) && (UI.eqr @myb, myb) && (UI.eqr @mye, mye)
        @mxb = mxb
        @mxe = mxe
        @myb = myb
        @mye = mye
        layer&.break_layout
        true
      end, def m
        (UI.eqr @mxb, @mxe) && (UI.eqr @myb, @mye) ? (UI.eqr @mxb, @myb) ? @mxb : [@mxb, @myb] : [@mxb, @mxe, @myb, @mye]
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

      param_prefix :stroke

      param def stroke_size! size
        return if @stroke_size == size
        @stroke_size = size
        @area.stroke_size = size
        layer&.break_layout
        true
      end

      param def spin! spin = nil, &b
        return spin! b[@spin] if b
        return if @spin == spin
        @spin = spin
        spin *= Math::PI * 2 if spin.is_a? Rational
        @scene.spin! spin
      end

      param_delegate :@scene,
        :scale

      param_delegate :@area, 
        :stroke_color, 
        :stroke_join, 
        :stroke_cap,
        :color

      param def color! *color
        @area.fill_color = color
      end, def color
        @area.fill_color
      end

      param def blunt! blunt, clip_blunt = true
        change = false
        change = @area.blunt! blunt if blunt
        if clip_blunt
          clip_blunt = blunt if clip_blunt == true
          change = (@clip_area.blunt! clip_blunt or change)
        end
        change
      end, def blunt clip = false
        clip ? @clip_area.blunt : @area.blunt
      end

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

      param def layout! layout = @layout, **params
        return if @layout == layout && params.empty?
        _layout = UI.layout(layout).tune **params
        @layout = layout
        return true if @_layout == _layout
        @_layout = _layout
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

      flag :show, set: :set_show, get: :get_show

      def hide!
        show! false
      end

      flag :layoutic, nil: true, set: :set_layoutic
      flag :scenic, nil: true, set: :set_scenic, get: :get_scenic

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

      flag :keyboardy
      flag :mousy, nil: true
      flag :focus, set: :set_focus, get: :keyboard_top?
      flag :pin, set: :set_pin, get: :pin_top?

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
        @clip_area = @clip_scene.rectangle! at: false, fill_color: false
        @pads = []
        @x = @y = :layout
        @w = @h = 100
        @spin = 0
        @mxb = @mxe = @myb = @mye = 0
        @stroke_size = 0
        @layout = nil
        @_layout = UI.layout
      end

      def pad_tree
        @pads.map{ [it, it.pad_tree] }.to_h
      end

      def sketch p0
        @clip_scene.clip! @clip_area

        on_mouse_down!{ mouse_down it }
        on_mouse_up!{ mouse_up it }
        on_mouse_enter!{ mouse_enter it }
        on_mouse_leave!{ mouse_leave it }
        on_mouse_move!{ mouse_move it }
        on_focus_enter!{ focus_enter it }
        on_focus_leave!{ focus_leave it }
        on!(KeyboardOfferEvent){ keyboard_offer it }
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
        e.resolve
      end

      def focus_leave e
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
        when :end
          pcw - sw
        when :begin
          0
        when :center
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
        when :end
          pch - sh
        when :begin
          0
        when :center
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
        @_layout.arrange self
      end

      def fit_w
        @mxb + @mxe + @_layout.fit_w(self)
      end

      def fit_h
        @myb + @mye + @_layout.fit_h(self)
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
          else raise @h.begin
          end
          e = case @h.end
          when Rational
            m
          when Numeric
            @h.end < 0 ? m : @h.end
          when nil
            Float::INFINITY
          else raise @h.end
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

      def set_layoutic layoutic
        @layoutic = layoutic
        layer&.break_layout
        true
      end

      def set_scenic scenic
        @scene.set_show scenic
      end

      def get_scenic
        @scene.show? true
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
        @scene.show? false
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
        layer&.update_pin_pad nil
      end

      def set_pin set
        set ? pin_request : pin_dispose
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