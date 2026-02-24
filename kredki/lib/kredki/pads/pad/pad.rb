require_relative 'pad_events'

module Kredki
  module Pads
    # Base class of visible Pads tree nodes.
    class Pad < Service
      include PadEvents

      # Set subject.
      def subject! subject = @subject
        return send_bundle :subject!, yield(self.subject) if block_given?
        return if @subject == subject
        @subject = subject
        set_subject subject
        true
      end

      # See #subject!.
      def subject= param
        send_bundle :subject!, param
      end

      # Get subject.
      def subject
        @subject
      end

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
        send_bundle :x!, param
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
        send_bundle :y!, param
      end

      # Get position along the X axis.
      def y
        @y
      end

      # Set position along X and Y axes.
      def xy! x = @x, y = x
        return send_bundle :xy!, yield(self.xy) if block_given?
        return if (Util.eqr @y, y) && (Util.eqr @x, x)
        @x = x
        @y = y
        layer&.break_layout
        true
      end
      
      # See #xy!.
      def xy= param
        send_bundle :xy!, param
      end

      # Get position along X and Y axes.
      def xy
        [@x, @y]
      end

      # Set width.
      def w! w = @w, **ka
        return w! yield self.w if block_given?
        unless Util.eqr @w, w
          @w = w
          layer&.break_layout
          true
        end | ka.count{ send_bundle "w_#{_1}!", _2 }.nonzero?
      end

      # See #w!.
      def w= param
        send_bundle :w!, param
      end

      # Get width.
      def w
        @w
      end
      
      # Set height.
      def h! h = @h, **ka
        return h! yield self.h if block_given?
        unless Util.eqr @h, h
          @h = h
          layer&.break_layout
          true
        end | ka.count{ send_bundle "h_#{_1}!", _2 }.nonzero?
      end

      # See #h!.
      def h= param
        send_bundle :h!, param
      end

      # Get height.
      def h
        @h
      end

      # Set width and height.
      def wh! w = @w, h = w, **ka
        return send_bundle :wh!, yield(self.wh) if block_given?
        if @w != w || @h != h
          @w = w
          @h = h
          layer&.break_layout
          true
        end | ka.count{ send_bundle "wh_#{_1}!", _2 }.nonzero?
      end

      # See #wh!.
      def wh= param
        send_bundle :wh!, param
      end
      
      # Get width and height.
      def wh
        [@w, @h]
      end

      # Set width limit.
      def w_limit! w_limit = @w_limit
        return w_limit! yield self.w_limit if block_given?
        raise_ia w_limit, "Rational limit disabled." if Rational === w_limit
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
        raise_ia h_limit, "Rational limit disabled." if Rational === h_limit
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
        return send_bundle :wh_limit!, yield(self.wh_limit) if block_given?
        w_limit!(w) | h_limit!(h)
      end

      # See #wh_limit!.
      def wh_limit= param
        send_bundle :wh_limit!, param
      end

      # Get width and height limit.
      def wh_limit
        [@w_limit, @h_limit]
      end

      # Set X start margin.
      def mxs! m = @mxs
        return mxs! yield @mxs if block_given?
        return if Util.eqr @mxs, m
        @mxs = m
        layer&.break_layout
        true
      end

      # See #mxs!.
      def mxs= param
        send_bundle :mxs!, param
      end

      # Get X start margin.
      def mxs
        @mxs
      end

      # Set X end margin.
      def mxe! m = @mxe
        return mxe! yield @mxe if block_given?
        return if Util.eqr @mxe, m
        @mxe = m
        layer&.break_layout
        true
      end

      # See #mxe!.
      def mxe= param
        send_bundle :mxe!, param
      end

      # Get X end margin.
      def mxe
        @mxe
      end

      # Set Y start margin.
      def mys! m = @mys
        return mys! yield @mys if block_given?
        return if Util.eqr @mys, m
        @mys = m
        layer&.break_layout
        true
      end

      # See #mys!.
      def mys= param
        send_bundle :mys!, param
      end

      # Get Y start margin.
      def mys
        @mys
      end

      # Set Y end margin.
      def mye! m = @mye
        return mye! yield @mye if block_given?
        return if Util.eqr @mye, m
        @mye = m
        layer&.break_layout
        true
      end

      # See #mye!.
      def mye= param
        send_bundle :mye!, param
      end

      # Get Y end margin.
      def mye
        @mye
      end

      # Set X start and X end margin.
      def mx! mt = @mxs, mh = mt
        return send_bundle :mx!, yield(self.mx) if block_given?
        return if (Util.eqr @mxs, mt) && (Util.eqr @mxe, mh)
        @mxs = mt
        @mxe = mh
        layer&.break_layout
        true
      end

      # See #mx!.
      def mx= param
        send_bundle :mx!, param
      end

      # Get X start and X end margin.
      def mx
        [@mxs, @mxe]
      end

      # Set Y start and X end margin.
      def my! mys = @mys, mye = mys
        return send_bundle :my!, yield(self.my) if block_given?
        return if (Util.eqr @mys, mys) && (Util.eqr @mye, mye)
        @mys = mys
        @mye = mye
        layer&.break_layout
        true
      end

      # See #my!.
      def my= param
        send_bundle :my!, param
      end

      # Get Y start and Y end margin.
      def my
        [@mys, @mye]
      end

      # Set X and Y start and X and Y end margin.
      def m! mxs = @mxs, mys = mxs, mxe = mxs, mye = mys, **ka
        return send_bundle :m!, yield(self.m) if block_given?
        unless (Util.eqr @mxs, mxs) && (Util.eqr @mxe, mxe) && (Util.eqr @mys, mys) && (Util.eqr @mye, mye)
          @mxs = mxs
          @mxe = mxe
          @mys = mys
          @mye = mye
          layer&.break_layout
          true
        end | send_branch(:m, ka, "")
      end

      # See #m!.
      def m= param
        send_bundle :m!, param
      end

      # Get X and Y start and X and Y end margin.
      def m
        [@mxs, @mys, @mxe, @mye]
      end

      # Set inner margin.
      def mi! mi = @mi
        return mi! yield @mi if block_given?
        return if Util.eqr @mi, mi
        @mi = mi
        layer&.break_layout
        true
      end

      # See #mi!.
      def mi= param
        send_bundle :mi!, param
      end

      # Get inner margin.
      def mi
        @mi
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
        send_bundle :rot!, param
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

      # Set opacity.
      def opacity! opacity = @opacity
        return opacity! yield @opacity if block_given?
        return if @opacity == opacity
        @opacity = opacity
        opacity *= 255 if opacity.is_a? Rational
        @scene.opacity! opacity
      end

      # See #opacity!.
      def opacity= param
        send_bundle :opacity!, param
      end

      # Get opacity.
      def opacity
        @opacity
      end

      # Set mouse cursor.
      def mouse_cursor! mouse_cursor = @mouse_cursor
        return send_bundle :mouse_cursor!, yield(self.mouse_cursor) if block_given?
        return if @mouse_cursor == mouse_cursor
        @mouse_cursor = mouse_cursor
        window.mouse_stale = true
        true
      end

      # See #mouse_cursor!.
      def mouse_cursor= param
        send_bundle :mouse_cursor!, param
      end

      # Get mouse_cursor.
      def mouse_cursor
        @mouse_cursor
      end

      # [Create] and attach area and optionally clip area.
      def area! area = BlockShapeArea, clip: :auto, &block
        a = case area
        when Class
          area.new(&block)
        when Proc
          BlockShapeArea.new(&area)
        else
          area
        end
        unless @area == a
          a.alter **@area, filter_keywords: true
          a.attach @scene, true, @area
          @area.detach
          @area = a
          true
        end | 
        case clip
        when :auto
          clip_area! area, &block if Class === area
        when false, nil
          false
        else
          clip_area! area, &block
        end
      end

      # See #area!.
      def area= param
        send_bundle :area!, param
      end

      # Get area.
      def area
        @area
      end

      # [Create] and attach clip area.
      def clip_area! area = nil, &block
        a = Class === area ? area.new(&block) : area
        return if @clip_area == a
        a.alter **@clip_area, filter_keywords: true
        @clip_scene.clip! a
        @clip_area = a
        true
      end

      # See #clip_area!.
      def clip_area= param
        send_bundle :clip_area!, param
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
        layout = Pads.layout layout
        return true if @pads_layout == layout
        @pads_layout = layout
        layer&.break_layout
        true
      end

      # See #layout!.
      def layout= param
        send_bundle :layout!, param
      end

      # Get layout.
      def layout
        @layout
      end

      # Set whether Pad is drawn on the scene and is layout part.
      #
      # All ancestors must be shown for the Paint to be displayed on the screen.
      def show! value = true
        return if (c = show) == (value = block_given? ? yield(c) : value == Not ? !c : value)
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
        return if (c = layoutic) == (value = block_given? ? yield(c) : value == Not ? !c : value)
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
        return if (c = scenic) == (value = block_given? ? yield(c) : value == Not ? !c : value)
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

      # Get whether mouse pointer is over Pad.
      def mouse_in?
        layer&.layer_check_mouse_in self or false
        # layer&.mouse_pad&.pad_lineage&.any?{ _1 == self } || false
      end

      # Get whether mouse pointer is directly over Pad.
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

      # Get whether mouse pointer is pinned to Pad.
      def pin_in? button = nil
        layer&.pin_check self, button, false
      end

      # Get whether mouse pointer is directly pinned to Pad.
      def pin_top? button = nil
        layer&.pin_check self, button, true
      end

      # Set whether Pad can be direct keyboard events target.
      def keyboardy! value = true
        return if (c = keyboardy) == (value = block_given? ? yield(c) : value == Not ? !c : value)
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
        return if (c = mousy) == (value = block_given? ? yield(c) : value == Not ? !c : value)
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

      # Set whether is disabled.
      def disabled! value = true
        return if (c = disabled) == (value = block_given? ? yield(c) : value == Not ? !c : value)
        @disabled = value
        repaint
        true
      end

      # See #disabled!.
      def disabled= value
        disabled! value
      end
      
      # Get whether is disabled.
      def disabled
        @disabled
      end

      # See #disabled.
      def disabled?
        !!disabled || pad_lineage(false).any?{|it| it.disabled }
      end
      
      # Begin drag.
      def drag! start_xy = nil, button = nil
        mouse_xy = window.mouse_xy
        pin_request start_xy || mouse_xy, button, true
        event = MousePointerDragEvent.new Kredki.mouse, PositionEvent.new(*mouse_xy)
        event.start = true
        report event
      end

      # Detach all contained pads.
      def clear!
        pads, @pads = @pads, []
        pads.each do |pad|
          pad.detach true
        end
        layer&.break_layout unless pads.empty?
      end

      # Attach +pad+ do self.
      def put! pad, *a, at: nil, **ka, &b
        case pad 
        when String
          pad_mode = pad.start_with? "\xe1"
          pad.split("\x1e").each do |part|
            if pad_mode
              id = part.to_i
              c?{|c| c.object_id == id }&.then{|it| put! it }
              pad_mode = false
            else
              default_text part
              pad_mode = true
            end
          end
        else
          at = nil if at == self
          pad.attach self, at: at
          pad.alter(*a, **ka, &b)
        end
      end

      # Attach self to +parent+.
      def attach parent, at: nil
        super
        # parent&.sd?(Pad)&.put_pad self, at
      end

      # Detach from parents.
      def detach transfer = false
        super
        pad_detach transfer
      end

      # Push the feature.
      def << feature
        case feature
        when Pad
          put! feature
        when String
          new TextPad, feature
        else
          super
        end
      end
      
      # :section: LEVEL 2

      def initialize
        super
        @x = @y = Auto
        @w = @h = Auto
        @w_limit = @h_limit = nil
        @rot = 0
        @opacity = 255
        @mxs = @mxe = @mys = @mye = 0
        @mouse_cursor = nil
        @pad_parent = nil
        @scene = Scene.new
        initialize_area
        @clip_scene = @scene.scene!
        @clip_area = @clip_scene.rectangle! at: false, fill: false
        @pads = []
        @layout = nil
        @pads_layout = Pads.layout
      end

      def to_s
        "\x1e#{object_id}\x1e"
      end

      def initialize_area
        @area = @scene.rectangle! show: false
      end

      def pad_tree
        @pads.map{|it| [it, it.pad_tree] }.to_h
      end

      def sketch_service
        sketch
        presence
        behavior
      end

      def sketch
      end

      def presence
        @clip_scene.clip! @clip_area
      end

      def repaint event = nil
      end

      def behavior
        on_mouse_press do: method(:mouse_press)
        on_mouse_release do: method(:mouse_release)
        on_mouse_enter do: method(:mouse_enter)
        on_mouse_leave do: method(:mouse_leave)
        on_mouse_move do: method(:mouse_move)
        on_focus_enter do: method(:focus_enter)
        on_focus_leave do: method(:focus_leave)
        on FocusOfferEvent, do: method(:keyboard_offer)
      end

      def keyboard_offer e
        e.close if keyboardy? && keyboard_request
      end

      def mouse_enter e
      end

      def mouse_leave e
      end

      def mouse_move e
      end

      def mouse_press e
        report FocusOfferEvent.new if e.button.id == :primary
        pin_request e.xy, e.button.id
        e.close
      end

      def mouse_release e
        pin_dispose e.button.id
        if !e.drag && include_point?(*layer.translate(*e.xy, self))
          report MouseButtonClickEvent.new e
        end
        e.close
      end

      def focus_enter e
      end

      def focus_leave e
      end

      def set_subject subject
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
          while pad && !pad.s?(WindowScene)
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
        @scene.detach
        if @pad_parent
          @pad_parent.remove_pad self, transfer
          @pad_parent = nil
          grand_detach
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
        if removed
          layer&.break_layout
        end
        removed
      end

      def set_xy x, y
        @scene.xy! x.floor, y.floor
      end

      def get_x pclw, sw, ax
        case @x
        when Rational
          @x * pclw - sw * 0.5
        when Proc
          @x[pclw, sw]
        when Range
          ax + @x.begin
        when Start
          0
        when Center
          (pclw - sw) * 0.5
        when End
          pclw - sw
        when Auto
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
        when Start
          0
        when Center
          (pch - sh) * 0.5
        when End
          pch - sh
        when Auto
          ay
        when Numeric
          @y
        else raise_is @y
        end
      end

      def set_size w, h
        mx = @mxs + @mxe
        my = @mys + @mye
        @area.wh! w.floor, h.floor
        @scene.pivot_xy! w * 0.5, h * 0.5
        @clip_area.wh! (w - mx).floor, (h - my).floor
      end

      def layout_pads
        pads.filter{|it| it.layoutic? }
      end

      def arranged_pads
        pads
      end

      def arrange
        @pads_layout.arrange self
      end

      def fit_w
        @mxs + @mxe + @pads_layout.fit_w(self)
      end

      def min_w
        m = @mxs + @mxe
        mw = min_wv(m)
        mw = [mw, min_wl(@w_limit, m)].max if @w_limit
        mw
      end

      def min_wv m
        w = case @w
        when Rational, Proc
          m
        when Fit
          fit_w
        when Auto
          @area.w
        when :h
          get_h
        when Numeric
          @w < 0 ? m : @w
        else
          raise_is @w
        end
      end

      def min_wl limit, m
        case limit
        when Fit
          fit_w
        when Auto
          @area.w
        when Numeric
          limit < 0 ? m : limit
        when Range
          min_wl limit.begin, m
        else
          m
        end
      end

      def get_w tw = nil, h = nil
        get_wl @w, @w_limit, tw, h
      end

      def get_wl w, l, tw, h = nil
        cw = get_wv w, tw, h
        case l
        when nil
          cw
        when Range
          cw = [cw, get_wv(l.begin, tw, h)].max if l.begin
          cw = [cw, get_wv(l.end, tw, h)].min if l.end
          cw
        else
          [cw, get_wv(l, tw, h)].min
        end
      end

      def get_wr pad, r, tw
        @pads_layout.get_wr self, tw, pad, r
      end

      def get_wv w, tw, h
        case w
        when Rational
          @pad_parent.get_wr self, w, tw || @pad_parent.get_w
        when Proc
          w[tw || @pad_parent.get_w]
        when Fit
          fit_w
        when Auto
          @area.w
        when :h
          h || get_h
        when Numeric
          w < 0 ? (tw || @pad_parent.get_w) + w : w
        else
          raise_ia w
        end
      end

      def fit_h
        @mys + @mye + @pads_layout.fit_h(self)
      end

      def min_h
        m = @mys + @mye
        mh = min_hv(m)
        mh = [mh, min_hl(@h_limit, m)].max if @h_limit
        mh
      end

      def min_hv m
        case @h
        when Rational, Proc
          m
        when Fit
          fit_h
        when Auto
          @area.h
        when :w
          get_w
        when Numeric
          @h < 0 ? m : @h
        else
          raise_is @h
        end
      end

      def min_hl limit, m
        case limit
        when Fit
          fit_h
        when Auto
          @area.h
        when Numeric
          limit < 0 ? m : limit
        when Range
          min_hl limit.begin, m
        else
          m
        end
      end

      def get_h th = nil, w = nil
        get_hl @h, @h_limit, th, w
      end

      def get_hl h, l, th, w = nil
        ch = get_hv h, th, w
        case l
        when nil
          ch
        when Range
          ch = [ch, get_hv(l.begin, th, w)].max if l.begin
          ch = [ch, get_hv(l.end, th, w)].min if l.end
          ch
        else
          [ch, get_hv(l, th, w)].min
        end
      end

      def get_hr pad, r, th
        @pads_layout.get_hr self, th, pad, r
      end

      def get_hv h, th, w
        case h
        when Rational
          @pad_parent.get_hr self, h, th || @pad_parent.get_h
        when Proc
          h[th || @pad_parent.get_h]
        when Fit
          fit_h
        when Auto
          @area.h
        when :w
          w || get_w
        when Numeric
          h < 0 ? (th || @pad_parent.get_h) + h : h
        else
          raise_ia h
        end
      end

      def set_margin
        x = @mxs.floor
        y = @mys.floor
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

      def check_mouse_in pad
        sa? pad
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
        super(event, path == true ? pad_lineage.to_a.reverse : path, instant)
      end

      def c_set_parent at
        return if @pad_parent
        set_pad_parent @parent.sa?(Pad), at
      end

      def set_pad_parent pad_parent, at
        @pad_parent = pad_parent
        @pad_parent&.put_pad self, at
      end

      def default_text text
        new TextPad, text
      end
    end
  end
end