require_relative 'service'
require_relative 'pad_event_manager'
require_relative 'pad_events'
require_relative 'pad_base'
require_relative 'pad_inherited'

module Kredki
  module UI
    # Base class of visible UI tree nodes.
    class Pad < Service
      include PadBase
      include PadEvents
      extend PadInherited

      # Set position along the X axis.
      def x! x = @x
        return x! yield @x if block_given?
        return if Util.eqr @x, x
        @x = x
        layer&.break_layout
        true
      end
      
      # See #x!.
      def x= param
        send_ahp :x!, param
      end

      # Get position along the X axis.
      def x
        @x
      end

      # Set position along the Y axis.
      def y! y = @y
        return y! yield @y if block_given?
        return if Util.eqr @y, y
        @y = y
        layer&.break_layout
        true
      end

      # See #y!.
      def y= param
        send_ahp :y!, param
      end

      # Get position along the X axis.
      def y
        @y
      end

      # Set position along X and Y axes.
      def xy! x = @x, y = x
        return send_ahp :xy!, yield(self.xy) if block_given?
        return if (Util.eqr @y, y) && (Util.eqr @x, x)
        @x = x
        @y = y
        layer&.break_layout
        true
      end
      
      # See #xy!.
      def xy= param
        send_ahp :xy!, param
      end

      # Get position along X and Y axes.
      def xy
        [@x, @y]
      end

      # Set width.
      def w! w = @w, **na
        return w! yield self.w if block_given?
        unless Util.eqr @w, w
          @w = w
          layer&.break_layout
          true
        end | na.count{ send_ahp "w_#{_1}!", _2 }.nonzero?
      end

      # See #w!.
      def w= param
        send_ahp :w!, param
      end

      # Get width.
      def w
        @w
      end
      
      # Set height.
      def h! h = @h, **na
        return h! yield self.h if block_given?
        unless Util.eqr @h, h
          @h = h
          layer&.break_layout
          true
        end | na.count{ send_ahp "h_#{_1}!", _2 }.nonzero?
      end

      # See #h!.
      def h= param
        send_ahp :h!, param
      end

      # Get height.
      def h
        @h
      end

      # Set width and height.
      def wh! w = @w, h = w, **na
        return send_ahp :wh!, yield(self.wh) if block_given?
        if @w != w || @h != h
          @w = w
          @h = h
          layer&.break_layout
          true
        end | na.count{ send_ahp "wh_#{_1}!", _2 }.nonzero?
      end

      # See #wh!.
      def wh= param
        send_ahp :wh!, param
      end
      
      # Get width and height.
      def wh
        [@w, @h]
      end

      # Set width limit.
      def w_limit! w_limit = @w_limit
        return w_limit! yield self.w_limit if block_given?
        return if @w_limit = w_limit
        @w_limit = w_limit
        layer&.break_layout
        true
      end

      # See #w_limit!.
      def w_limit= param
        w_limit! param
      end

      # Get width limit.
      def w_limit
        @w_limit
      end
      
      # Set height limit.
      def h_limit! h_limit = @h_limit
        return h_limit! yield self.h_limit if block_given?
        return if @h_limit = h_limit
        @h_limit = h_limit
        layer&.break_layout
        true
      end

      # See #h_limit!.
      def h_limit= param
        h_limit! param
      end

      # Get height limit.
      def h_limit
        @h_limit
      end

      # Set width and height limit.
      def wh_limit! w = @w_limit, h = w
        return send_ahp :wh_limit!, yield(self.wh_limit) if block_given?
        if @w_limit != w || @h_limit != h
          @w_limit = w
          @h_limit = h
          layer&.break_layout
          true
        end
      end

      # See #wh_limit!.
      def wh_limit= param
        send_ahp :wh_limit!, param
      end

      # Get width and height limit.
      def wh_limit
        [@w_limit, @h_limit]
      end

      # Set X start margin.
      def margin_xs! m = @margin_xs
        return margin_xs! yield @margin_xs if block_given?
        return if Util.eqr @margin_xs, m
        @margin_xs = m
        layer&.break_layout
        true
      end

      # See #margin_xs!.
      def margin_xs= param
        send_ahp :margin_xs!, param
      end

      # Get X start margin.
      def margin_xs
        @margin_xs
      end

      # Set X end margin.
      def margin_xe! m = @margin_xe
        return margin_xe! yield @margin_xe if block_given?
        return if Util.eqr @margin_xe, m
        @margin_xe = m
        layer&.break_layout
        true
      end

      # See #margin_xe!.
      def margin_xe= param
        send_ahp :margin_xe!, param
      end

      # Get X end margin.
      def margin_xe
        @margin_xe
      end

      # Set Y start margin.
      def margin_ys! m = @margin_ys
        return margin_ys! yield @margin_ys if block_given?
        return if Util.eqr @margin_ys, m
        @margin_ys = m
        layer&.break_layout
        true
      end

      # See #margin_ys!.
      def margin_ys= param
        send_ahp :margin_ys!, param
      end

      # Get Y start margin.
      def margin_ys
        @margin_ys
      end

      # Set Y end margin.
      def margin_ye! m = @margin_ye
        return margin_ye! yield @margin_ye if block_given?
        return if Util.eqr @margin_ye, m
        @margin_ye = m
        layer&.break_layout
        true
      end

      # See #margin_ye!.
      def margin_ye= param
        send_ahp :margin_ye!, param
      end

      # Get Y end margin.
      def margin_ye
        @margin_ye
      end

      # Set X start and head margin.
      def margin_x! mt = @margin_xs, mh = mt
        return send_ahp :margin_x!, yield(self.margin_x) if block_given?
        return if (Util.eqr @margin_xs, mt) && (Util.eqr @margin_xe, mh)
        @margin_xs = mt
        @margin_xe = mh
        layer&.break_layout
        true
      end

      # See #margin_x!.
      def margin_x= param
        send_ahp :margin_x!, param
      end

      # Get X start and head margin.
      def margin_x
        [@margin_xs, @margin_xe]
      end

      # Set Y start and head margin.
      def margin_y! margin_ys = @margin_ys, margin_ye = margin_ys
        return send_ahp :margin_y!, yield(self.margin_y) if block_given?
        return if (Util.eqr @margin_ys, margin_ys) && (Util.eqr @margin_ye, margin_ye)
        @margin_ys = margin_ys
        @margin_ye = margin_ye
        layer&.break_layout
        true
      end

      # See #margin_y!.
      def margin_y= param
        send_ahp :margin_y!, param
      end

      # Get Y start and head margin.
      def margin_y
        [@margin_ys, @margin_ye]
      end

      # Set X and Y start and X and Y end margin.
      def margin! margin_xs = @margin_xs, margin_ys = margin_xs, margin_xe = margin_xs, margin_ye = margin_ys, **na
        return send_ahp :margin!, yield(self.m) if block_given?
        unless (Util.eqr @margin_xs, margin_xs) && (Util.eqr @margin_xe, margin_xe) && (Util.eqr @margin_ys, margin_ys) && (Util.eqr @margin_ye, margin_ye)
          @margin_xs = margin_xs
          @margin_xe = margin_xe
          @margin_ys = margin_ys
          @margin_ye = margin_ye
          layer&.break_layout
          true
        end | send_branch(:margin, na)
      end

      # See #margin!.
      def margin= param
        send_ahp :margin!, param
      end

      # Get X and Y start and X and Y end margin.
      def margin
        [@margin_xs, @margin_ys, @margin_xe, @margin_ye]
      end

      # Set inner margin.
      def margin_i! margin_i = @margin_i
        return margin_i! yield @margin_i if block_given?
        return if Util.eqr @margin_i, margin_i
        @margin_i = margin_i
        layer&.break_layout
        true
      end

      # See #margin_i!.
      def margin_i= param
        send_ahp :margin_i!, param
      end

      # Get inner margin.
      def margin_i
        @margin_i
      end

      # Set rotation angle around the pivot point.
      def rot! rot = @rot
        return rot! yield @rot if block_given?
        return if @rot == rot
        @rot = rot
        rot *= Math::PI * 2 if rot.is_a? Rational
        @scene.rot! rot
      end

      # See #rot!.
      def rot= param
        send_ahp :rot!, param
      end

      # Get rotation angle around the pivot point.
      def rot
        @rot
      end

      # Set magnification factor along the X axis.
      def mag_x! ...
        @scene.mag_x!(...)
      end

      # See #mag_x!.
      def mag_x= value
        @scene.mag_x = value
      end

      # Get magnification factor along the X axis.
      def mag_x
        @scene.mag_x
      end

      # Set magnification factor along the Y axis.
      def mag_y! ...
        @scene.mag_y!(...)
      end

      # See #mag_y!.
      def mag_y= value
        @scene.mag_y = value
      end

      # Get magnification factor along the Y axis.
      def mag_y
        @scene.mag_y
      end

      # Set magnification factor along X and Y axes.
      def mag! ...
        @scene.mag!(...)
      end

      # See #mag!.
      def mag= value
        @scene.mag = value
      end

      # Get magnification factor along X and Y axes.
      def mag
        @scene.mag
      end

      # Set area. Creates new Kredki::BlockShapeArea if +area+ is nil.
      def area! area = nil, &block
        if block
          if area
            area.alter &block
          else
            area = BlockShapeArea.new block
          end
        end
        return if @area == area
        area.alter_kwr **@area
        area.attach! @scene, true, @area
        @area.detach!
        @area = area
        true
      end

      # See #area!.
      def area= param
        send_ahp :area!, param
      end

      # Get area.
      def area
        @area
      end

      # Set clip area. Creates new Kredki::BlockShapeArea if +area+ is nil.
      def clip_area! area = nil, &block
        if block
          if area
            area.alter &block
          else
            area = BlockShapeArea.new block
          end
        end
        return if @clip_area == area
        area.alter_kwr **@clip_area
        @clip_scene.clip! area
        @clip_area = area
        true
      end

      # See #clip_area!.
      def clip_area= param
        send_ahp :clip_area!, param
      end

      # Get clip_area.
      def clip_area
        @clip_area
      end

      # Set layout.
      def layout! layout = nil
        return layout! yield @layout if block_given?
        return if @layout == layout
        @layout = layout
        layout = UI.layout layout
        return true if @ui_layout == layout
        @ui_layout = layout
        layer&.break_layout
        true
      end

      # See #layout!.
      def layout= param
        send_ahp :layout!, param
      end

      # Get layout.
      def layout
        @layout
      end

      # Set whether Pad is drawn on the scene and is layout part.
      #
      # All ancestors must be shown for the Paint to be displayed on the screen.
      def show! value = true
        return if (c = show) == (value = block_given? ? yield(c) : value == :not ? !c : value)
        set_show value
        true
      end

      # See #show!.
      def show= value
        show! value
      end
      
      # Get whether Pad is drawn on the screen.
      def show
        get_show
      end

      # See #show.
      def show?
        !!show
      end

      # Stop showing the Paint. 
      def hide!
        show! false
      end

      # Set whether Pad is layout part.
      def layoutic! value = true
        return if (c = layoutic) == (value = block_given? ? yield(c) : value == :not ? !c : value)
        layer&.break_layout
        @layoutic = value
        true
      end

      # See #layoutic!.
      def layoutic= value
        layoutic! value
      end
      
      # Get whether Pad is layout part.
      def layoutic
        @layoutic || @layoutic.nil?
      end

      # See #layoutic.
      def layoutic?
        !!layoutic
      end

      # Set whether Pad is drawn on the scene.
      #
      # All ancestors must be shown for the Paint to be displayed on the screen.
      def scenic! value = true
        return if (c = scenic) == (value = block_given? ? yield(c) : value == :not ? !c : value)
        set_scenic value
        true
      end

      # See #scenic!.
      def scenic= value
        scenic! value
      end
      
      # Get whether Pad is drawn on the scene.
      def scenic
        get_scenic
      end

      # See #scenic.
      def scenic?
        !!scenic
      end

      # Get whether [+x+, +y+] is inside Pad area.
      def include_point? x, y
        @area.contain? x, y
      end

      # Get whether mouse cursor is over Pad.
      def mouse_in?
        layer&.mouse_pad&.pad_lineage&.any?{ _1 == self } || false
      end

      # Get whether mouse cursor is directly over Pad.
      def mouse_top?
        layer&.mouse_pad == self
      end

      # Get whether keyboard events are reaching Pad.
      def keyboard_in?
        layer&.keyboard_pad&.pad_lineage&.any?{ _1 == self } || false
      end

      # Get whether keyboard events are reaching Pad direcly.
      def keyboard_top?
        layer&.keyboard_pad == self
      end

      # Get whether mouse cursor is pinned to Pad.
      def pin_in? button = nil
        layer&.pin_check self, button, false
      end

      # Get whether mouse cursor is directly pinned to Pad.
      def pin_top? button = nil
        layer&.pin_check self, button, true
      end

      # Set whether Pad can be direct keyboard events target.
      def keyboardy! value = true
        return if (c = keyboardy) == (value = block_given? ? yield(c) : value == :not ? !c : value)
        @keyboardy = value
        true
      end

      # See #keyboardy!.
      def keyboardy= value
        keyboardy! value
      end
      
      # Get whether Pad can be direct keyboard events target.
      def keyboardy
        @keyboardy
      end

      # See #keyboardy.
      def keyboardy?
        !!keyboardy
      end
      
      # Set whether Pad can be direct mouse events target.
      def mousy! value = true
        return if (c = mousy) == (value = block_given? ? yield(c) : value == :not ? !c : value)
        @mousy = value
        true
      end

      # See #mousy!.
      def mousy= value
        mousy! value
      end
      
      # Get whether Pad can be direct mouse events target.
      def mousy
        @mousy || @mousy.nil?
      end

      # See #mousy.
      def mousy?
        !!mousy
      end
      
      # Begin drag.
      def drag! start_xy = nil, button = nil
        mouse_xy = Kredki.mouse.xy
        pin_request start_xy || mouse_xy, button, true
        report MouseMoveEvent.new(:start, nil, *mouse_xy)
      end

      # Detach all contained pads.
      def clear!
        pads, @pads = @pads, []
        pads.each do |pad|
          pad.detach! true
        end
        layer&.break_layout unless pads.empty?
      end

      # Attach +pad+ do self.
      def put! pad, *a, at: nil, **na, &b
        pad.pad_detach
        pad.set_pad_parent self, at
        pad.alter(*a, **na, &b)
      end

      # Attach self to +parent+.
      def attach! parent
        super
        parent&.grand(Pad)&.put_pad self
      end

      # Detach from containing Pad.
      def detach! transfer = false
        super
        pad_detach transfer
      end

      # Push the feature.
      def << feature
        case feature
        when Pad
          put! feature
        else
          super
        end
      end
      
      # :section: LEVEL 2

      def initialize
        super
        @x = @y = :layout
        @w = @h = :layout
        @w_limit = @h_limit = nil
        @rot = 0
        @margin_xs = @margin_xe = @margin_ys = @margin_ye = 0
        @pad_parent = nil
        @scene = Scene.new
        initialize_area
        @clip_scene = @scene.scene!
        @clip_area = @clip_scene.rectangle! at: false, fill: false
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
        report KeyboardOfferEvent.new if e.button.id == :primary
        pin_request e.xy, e.button.id
        e.resolve
      end

      def mouse_up e
        pin_dispose e.button.id
        if !e.drag && include_point?(*layer.translate(*e.xy, self))
          report MouseClickEvent.new e.origin
        end
        e.resolve
      end

      def focus_enter e
      end

      def focus_leave e
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
      
      def clw
        @clip_area.w
      end

      def clh
        @clip_area.h
      end

      def clwh
        @clip_area.wh
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

      def set_xy x, y
        @scene.xy! x, y
      end

      def get_x pclw, sw, ax
        case @x
        when Rational
          @x * pclw - sw * 0.5
        when Proc
          @x[pclw, sw]
        when Range
          ax + @x.begin
        when :e
          pclw - sw
        when :s
          0
        when :c
          (pclw - sw) * 0.5
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
        when :s
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
        margin_x = @margin_xs + @margin_xe
        margin_y = @margin_ys + @margin_ye
        @area.wh! w, h
        @scene.pivot_xy! w * 0.5, h * 0.5
        @clip_area.wh! w - margin_x, h - margin_y
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
        @margin_xs + @margin_xe + @ui_layout.fit_w(self)
      end

      def min_w
        m = @margin_xs + @margin_xe
        w = case @w
        when Rational, Proc
          m
        when :fit
          fit_w
        when :layout
          @area.w
        when Numeric
          @w < 0 ? m : @w
        else
          raise_is @w
        end
        w_min = case @w_limit
        when Rational, Proc
          m
        when :fit
          fit_w
        when :layout
          @area.w
        when Numeric
          @w_limit < 0 ? m : @w_limit
        else
          w
        end
        [w, w_min].max
      end

      def get_w tw = nil
        get_wl @w, @w_limit, tw
      end

      def get_wl w, l, tw
        cw = get_wv w, tw
        case l
        when nil
          cw
        when Range
          cw = [cw, get_wv(l.begin, tw)].max if l.begin
          cw = [cw, get_wv(l.end, tw)].min if l.end
          cw
        else
          [cw, get_wv(l, tw)].min
        end
      end

      def get_wv w, tw
        case w
        when Rational
          (tw || @pad_parent.get_w) * w
        when Proc
          w[tw || @pad_parent.get_w]
        when :fit
          fit_w
        when :layout
          @area.w
        when Numeric
          w < 0 ? (tw || @pad_parent.get_w) + w : w
        else
          raise_ia w
        end
      end

      def fit_h
        @margin_ys + @margin_ye + @ui_layout.fit_h(self)
      end

      def min_h
        m = @margin_ys + @margin_ye
        h = case @h
        when Rational, Proc
          m
        when :fit
          fit_h
        when :layout
          @area.h
        when Numeric
          @h < 0 ? m : @h
        else
          raise_is @h
        end
        h_min = case @h_limit
        when Rational, Proc
          m
        when :fit
          fit_h
        when :layout
          @area.h
        when Numeric
          @h_limit < 0 ? m : @h_limit
        else
          h
        end
        [h, h_min].max
      end

      def get_h th = nil
        get_hl @h, @h_limit, th
      end

      def get_hl h, l, th
        ch = get_hv h, th
        case l
        when nil
          ch
        when Range
          ch = [ch, get_hv(l.begin, th)].max if l.begin
          ch = [ch, get_hv(l.end, th)].min if l.end
          ch
        else
          [ch, get_hv(l, th)].min
        end
      end

      def get_hv h, th
        case h
        when Rational
          (th || @pad_parent.get_h) * h
        when Proc
          h[th || @pad_parent.get_h]
        when :fit
          fit_h
        when :layout
          @area.h
        when Numeric
          h < 0 ? (th || @pad_parent.get_h) + h : h
        else
          raise_ia h
        end
      end

      def set_margin
        x = @margin_xs
        y = @margin_ys
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
            report ShowEvent.new, false
            @pads.each &:show_propagate
          else
            report HideEvent.new, false
            @pads.each &:hide_propagate
          end
        end
      end

      def get_show
        @scene.get_show false
      end

      def show_propagate
        if get_scenic
          report ShowEvent.new, false
          @pads.each &:show_propagate
        end
      end

      def hide_propagate
        if get_scenic
          report HideEvent.new, false
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

      def pin_request xy = nil, button = nil, drag = false
        layer&.update_pin_pad self, xy, button, drag
      end

      def pin_dispose button = nil
        layer&.update_pin_pad nil if !button || button == layer&.pin_button
      end

      def drag_check bxy, xy
        (bxy[0] - xy[0]) ** 2 + (bxy[1] - xy[1]) ** 2 > 100
      end

      def roi! x = 0, y = 0
        report ROIEvent.new *swh, x, y
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