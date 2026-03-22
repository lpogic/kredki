require_relative 'pad_events'

module Kredki
  module Pads
    # Base class of visible Pads tree nodes.
    class Pad < Service
      include PadEvents

      # Set subject.
      def set_subject subject = @subject
        return send_bundle :set_subject, yield(self.subject) if block_given?
        return if @subject == subject
        @subject = subject
        update_subject subject
        true
      end

      # See #set_subject.
      def subject= param
        send_bundle :set_subject, param
      end

      # Get subject.
      def subject
        @subject
      end

      # Set position along the X axis.
      def set_x x = @x
        return set_x yield @x if block_given?
        return if Util.eqr @x, x
        @x = x
        layer&.break_layout
        true
      end
      
      # See #set_x.
      def x= param
        send_bundle :set_x, param
      end

      # Get position along the X axis.
      def x
        @x
      end

      # Set position along the Y axis.
      def set_y y = @y
        return set_y yield @y if block_given?
        return if Util.eqr @y, y
        @y = y
        layer&.break_layout
        true
      end

      # See #set_y.
      def y= param
        send_bundle :set_y, param
      end

      # Get position along the X axis.
      def y
        @y
      end

      # Set position along X and Y axes.
      def set_xy x = @x, y = x
        return send_bundle :set_xy, yield(self.xy) if block_given?
        return if (Util.eqr @y, y) && (Util.eqr @x, x)
        @x = x
        @y = y
        layer&.break_layout
        true
      end
      
      # See #set_xy.
      def xy= param
        send_bundle :set_xy, param
      end

      # Get position along X and Y axes.
      def xy
        [@x, @y]
      end

      # Set size in the X axis.
      def set_size_x size_x = @size_x, **ka
        return set_size_x yield self.size_x if block_given?
        unless Util.eqr @size_x, size_x
          @size_x = size_x
          layer&.break_layout
          true
        end | send_branch(__method__, ka)
      end

      # See #set_size_x.
      def size_x= param
        send_bundle :set_size_x, param
      end

      # Get size in the X axis.
      def size_x
        @size_x
      end
      
      # Set size in the Y axis.
      def set_size_y size_y = @size_y, **ka
        return set_size_y yield self.size_y if block_given?
        unless Util.eqr @size_y, size_y
          @size_y = size_y
          layer&.break_layout
          true
        end | send_branch(__method__, ka)
      end

      # See #set_size_y.
      def size_y= param
        send_bundle :set_size_y, param
      end

      # Get size in the Y axis.
      def size_y
        @size_y
      end

      # Set size.
      def set_size size_x = @size_x, size_y = size_x, **ka
        return send_bundle :set_size, yield(self.size) if block_given?
        if @size_x != size_x || @size_y != size_y
          @size_x = size_x
          @size_y = size_y
          layer&.break_layout
          true
        end | send_branch(__method__, ka)
      end

      # See #set_size.
      def size= param
        send_bundle :set_size, param
      end
      
      # Get size.
      def size
        [@size_x, @size_y]
      end

      # Set size limit in the X axis.
      def set_size_x_limit size_x_limit = @size_x_limit
        return set_size_x_limit yield self.size_x_limit if block_given?
        raise_ia size_x_limit, "Rational limit disabled." if Rational === size_x_limit
        return if @size_x_limit = size_x_limit
        @size_x_limit = size_x_limit
        layer&.break_layout
        true
      end

      # See #set_size_x_limit.
      def size_x_limit= param
        set_size_x_limit param
      end

      # Get size limit in the X axis.
      def size_x_limit
        @size_x_limit
      end
      
      # Set size limit in the Y axis.
      def set_size_y_limit size_y_limit = @size_y_limit
        return set_size_y_limit yield self.size_y_limit if block_given?
        raise_ia size_y_limit, "Rational limit disabled." if Rational === size_y_limit
        return if @size_y_limit = size_y_limit
        @size_y_limit = size_y_limit
        layer&.break_layout
        true
      end

      # See #set_size_y_limit.
      def size_y_limit= param
        set_size_y_limit param
      end

      # Get size limit in the Y axis.
      def size_y_limit
        @size_y_limit
      end

      # Set size limit.
      def set_size_limit x_limit = @x_limit, y_limit = x_limit
        return send_bundle :set_size_limit, yield(self.size_limit) if block_given?
        set_size_x_limit(x_limit) | set_size_y_limit(y_limit)
      end

      # See #set_size_limit.
      def size_limit= param
        send_bundle :set_size_limit, param
      end

      # Get size limit.
      def size_limit
        [@w_limit, @h_limit]
      end

      # Set X start margin.
      def set_margin_xs m = @margin_xs
        return set_margin_xs yield @margin_xs if block_given?
        return if Util.eqr @margin_xs, m
        @margin_xs = m
        layer&.break_layout
        true
      end

      # See #set_margin_xs.
      def margin_xs= param
        send_bundle :set_margin_xs, param
      end

      # Get X start margin.
      def margin_xs
        @margin_xs
      end

      # Set X end margin.
      def set_margin_xe m = @margin_xe
        return set_margin_xe yield @margin_xe if block_given?
        return if Util.eqr @margin_xe, m
        @margin_xe = m
        layer&.break_layout
        true
      end

      # See #set_margin_xe.
      def margin_xe= param
        send_bundle :set_margin_xe, param
      end

      # Get X end margin.
      def margin_xe
        @margin_xe
      end

      # Set Y start margin.
      def set_margin_ys m = @margin_ys
        return set_margin_ys yield @margin_ys if block_given?
        return if Util.eqr @margin_ys, m
        @margin_ys = m
        layer&.break_layout
        true
      end

      # See #set_margin_ys.
      def margin_ys= param
        send_bundle :set_margin_ys, param
      end

      # Get Y start margin.
      def margin_ys
        @margin_ys
      end

      # Set Y end margin.
      def set_margin_ye m = @margin_ye
        return set_margin_ye yield @margin_ye if block_given?
        return if Util.eqr @margin_ye, m
        @margin_ye = m
        layer&.break_layout
        true
      end

      # See #set_margin_ye.
      def margin_ye= param
        send_bundle :set_margin_ye, param
      end

      # Get Y end margin.
      def margin_ye
        @margin_ye
      end

      # Set X start and X end margin.
      def set_margin_x mxs = @margin_xs, mxe = mxs
        return send_bundle :set_margin_x, yield(self.margin_x) if block_given?
        return if (Util.eqr @margin_xs, mxs) && (Util.eqr @margin_xe, mxe)
        @margin_xs = mxs
        @margin_xe = mxe
        layer&.break_layout
        true
      end

      # See #set_margin_x.
      def margin_x= param
        send_bundle :set_margin_x, param
      end

      # Get X start and X end margin.
      def margin_x
        [@margin_xs, @margin_xe]
      end

      # Set Y start and X end margin.
      def set_margin_y margin_ys = @margin_ys, margin_ye = margin_ys
        return send_bundle :set_margin_y, yield(self.margin_y) if block_given?
        return if (Util.eqr @margin_ys, margin_ys) && (Util.eqr @margin_ye, margin_ye)
        @margin_ys = margin_ys
        @margin_ye = margin_ye
        layer&.break_layout
        true
      end

      # See #set_margin_y.
      def margin_y= param
        send_bundle :set_margin_y, param
      end

      # Get Y start and Y end margin.
      def margin_y
        [@margin_ys, @margin_ye]
      end

      # Set X and Y start and X and Y end margin.
      def set_margin margin_xs = @margin_xs, margin_ys = margin_xs, margin_xe = margin_xs, margin_ye = margin_ys, **ka
        return send_bundle :set_margin, yield(self.m) if block_given?
        unless (Util.eqr @margin_xs, margin_xs) && (Util.eqr @margin_xe, margin_xe) && (Util.eqr @margin_ys, margin_ys) && (Util.eqr @margin_ye, margin_ye)
          @margin_xs = margin_xs
          @margin_xe = margin_xe
          @margin_ys = margin_ys
          @margin_ye = margin_ye
          layer&.break_layout
          true
        end | send_branch(__method__, ka)
      end

      # See #set_margin.
      def margin= param
        send_bundle :set_margin, param
      end

      # Get X and Y start and X and Y end margin.
      def margin
        [@margin_xs, @margin_ys, @margin_xe, @margin_ye]
      end

      # Set layout spacer.
      def set_spacer spacer = @spacer
        return set_spacer yield @spacer if block_given?
        return if Util.eqr @spacer, spacer
        @spacer = spacer
        layer&.break_layout
        true
      end

      # See #set_spacer.
      def spacer= param
        send_bundle :set_spacer, param
      end

      # Get inner margin.
      def spacer
        @spacer
      end

      # Set turn around the pivot point.
      def set_turn turn = @turn
        return set_turn yield @turn if block_given?
        return if @turn == turn
        @turn = turn
        @scene.set_turn turn
      end

      # See #set_turn.
      def turn= param
        send_bundle :set_turn, param
      end

      # Get turn around the pivot point.
      def turn
        @turn
      end

      # Set zoom in the X axis.
      def set_zoom_x ...
        @scene.set_zoom_x(...)
      end

      # See #set_zoom_x.
      def zoom_x= value
        @scene.zoom_x = value
      end

      # Get zoom in the X axis.
      def zoom_x
        @scene.zoom_x
      end

      # Set zoom in the Y axis.
      def set_zoom_y ...
        @scene.set_zoom_y(...)
      end

      # See #set_zoom_y.
      def zoom_y= value
        @scene.zoom_y = value
      end

      # Get zoom in the Y axis.
      def zoom_y
        @scene.zoom_y
      end

      # Set zoom in X and Y axes.
      def set_zoom ...
        @scene.set_zoom(...)
      end

      # See #set_zoom.
      def zoom= value
        @scene.zoom = value
      end

      # Get zoom in X and Y axes.
      def zoom
        @scene.zoom
      end

      # Set opacity.
      def set_opacity opacity = @opacity
        return set_opacity yield @opacity if block_given?
        return if @opacity == opacity
        @opacity = opacity
        opacity *= 255 if opacity.is_a? Rational
        @scene.set_opacity opacity
      end

      # See #set_opacity.
      def opacity= param
        send_bundle :set_opacity, param
      end

      # Get opacity.
      def opacity
        @opacity
      end

      # Set mouse cursor.
      def set_mouse_cursor mouse_cursor = @mouse_cursor
        return send_bundle :set_mouse_cursor, yield(self.mouse_cursor) if block_given?
        return if @mouse_cursor == mouse_cursor
        @mouse_cursor = mouse_cursor
        pane.mouse_stale = true
        true
      end

      # See #set_mouse_cursor.
      def mouse_cursor= param
        send_bundle :set_mouse_cursor, param
      end

      # Get mouse_cursor.
      def mouse_cursor
        @mouse_cursor
      end

      # [Create] and attach area and optionally clip area.
      def set_area area = BlockShapeArea, clip: :auto, &block
        a = case area
        when Class
          area.new(&block)
        when Proc
          BlockShapeArea.new(&area)
        else
          area
        end
        unless @area == a
          a.set **@area, filter_keywords: true
          a.attach @scene, true, @area
          @area.detach
          @area = a
          true
        end | 
        case clip
        when :auto
          set_clip_area area, &block if Class === area
        when false, nil
          false
        else
          set_clip_area area, &block
        end
      end

      # See #set_area.
      def area= param
        send_bundle :set_area, param
      end

      # Get area.
      def area
        @area
      end

      # [Create] and attach clip area.
      def set_clip_area area = nil, &block
        a = Class === area ? area.new(&block) : area
        return if @clip_area == a
        a.set **@clip_area, filter_keywords: true
        @clip_scene.set_clip a
        @clip_area = a
        true
      end

      # See #set_clip_area.
      def clip_area= param
        send_bundle :set_clip_area, param
      end

      # Get clip_area.
      def clip_area
        @clip_area
      end

      # Set layout.
      def set_layout layout = nil
        return set_layout yield @layout if block_given?
        return if @layout == layout
        @layout = layout
        layout = Pads.layout layout
        return true if @pads_layout == layout
        @pads_layout = layout
        layer&.break_layout
        true
      end

      # See #set_layout.
      def layout= param
        send_bundle :set_layout, param
      end

      # Get layout.
      def layout
        @layout
      end

      # Set whether Pad is scenic.
      #
      # All lower pads must also be scenic for the Pad to be displayed.
      def set_scenic value = true
        return if (c = scenic) == (value = block_given? ? yield(c) : value == Not ? !c : value)
        update_scenic value
        true
      end

      # See #set_scenic.
      def scenic= value
        set_scenic value
      end
      
      # Get whether Pad is scenic.
      def scenic
        get_scenic
      end

      # Get whether Pad is displayed
      def displayed
        @scene.displayed
      end

      # Set whether Pad is layoutic.
      #
      # Layoutic pad occupy place in layout even if it is not scenic.
      def set_layoutic value = true
        return if (c = layoutic) == (value = block_given? ? yield(c) : value == Not ? !c : value)
        layer&.break_layout
        @layoutic = value
        true
      end

      # See #set_layoutic.
      def layoutic= value
        set_layoutic value
      end
      
      # Get whether Pad is layoutic.
      def layoutic
        @layoutic || @layoutic.nil?
      end

      # Get whether [+x+, +y+] is inside Pad area.
      def include_point x, y
        @area.include_point x, y
      end

      # Get whether mouse pointer events are reaching Pad.
      def mouse_in
        layer&.layer_check_mouse_in self or false
      end

      # Get whether Pad is mouse pointer events target.
      def mouse_top
        layer&.mouse_pad == self
      end

      # Get whether keyboard events are reaching Pad.
      def keyboard_in
        top = layer&.keyboard_pad
        top == self || top&.lower_pad_iterator&.any?{ _1 == self } || false
      end

      # Get whether Pad is keyboard events target.
      def keyboard_top
        layer&.keyboard_pad == self
      end

      # Get whether mouse pointer is pinned to Pad.
      def pin_in button = nil
        layer&.pin_check self, button, false
      end

      # Get whether mouse pointer is directly pinned to Pad.
      def pin_top button = nil
        layer&.pin_check self, button, true
      end

      # Set whether Pad can be keyboard events target.
      def set_keyboardy value = true
        return if (c = keyboardy) == (value = block_given? ? yield(c) : value == Not ? !c : value)
        @keyboardy = value
        true
      end

      # See #set_keyboardy.
      def keyboardy= value
        set_keyboardy value
      end
      
      # Get whether Pad can be keyboard events target.
      def keyboardy
        @keyboardy
      end
      
      # Set whether Pad can be mouse events target.
      def set_mousy value = true
        return if (c = mousy) == (value = block_given? ? yield(c) : value == Not ? !c : value)
        @mousy = value
        true
      end

      # See #set_mousy.
      def mousy= value
        set_mousy value
      end
      
      # Get whether Pad can be mouse events target.
      def mousy
        @mousy || @mousy.nil?
      end

      # Set whether is disabled.
      def set_disabled value = true
        return if (c = disabled) == (value = block_given? ? yield(c) : value == Not ? !c : value)
        @disabled = value
        repaint
        true
      end

      # See #set_disabled.
      def disabled= value
        set_disabled value
      end
      
      # Get whether is disabled.
      def disabled
        @disabled
      end

      # Get whether self or any lower is disabled.
      def in_disabled
        disabled || find_lower(Pad){|it| it.disabled }
      end
      
      # Start drag.
      def start_drag start_xy = nil, button = nil
        mouse_xy = window.mouse_xy
        pin_request start_xy || mouse_xy, button, true
        event = MousePointerDragEvent.new(Kredki.mouse, PositionEvent.new(*mouse_xy)).set button: button, start: true
        report event
      end

      # Detach all contained pads.
      def clear
        pads, @pads = @pads, []
        pads.each do |pad|
          pad.detach true
        end
        layer&.break_layout unless pads.empty?
      end

      # Put subject.
      def put subject, *a, at: nil, **ka, &b
        case subject 
        when String
          pad_mode = subject.start_with? "\xe1"
          subject.split("\x1e").each do |part|
            if pad_mode
              id = part.to_i
              pad = find{|c| c.object_id == id }
              put pad if pad
              pad_mode = false
            else
              default_text part
              pad_mode = true
            end
          end
        when Service
          at = nil if at == self
          subject.attach self, at: at
          subject.set *a, **ka, &b
        else super
        end
      end

      # Detach from lower.
      def detach transfer = false
        super
        pad_detach transfer
      end

      # Set a feature recognized by its class.
      def << feature
        case feature
        when Pad, String
          put feature
        else
          super
        end
      end
      
      # :section: LEVEL 2

      def initialize
        super
        @x = @y = Auto
        @size_x = @size_y = Auto
        @size_x_limit = @size_y_limit = nil
        @turn = 0
        @opacity = 255
        @margin_xs = @margin_xe = @margin_ys = @margin_ye = 0
        @mouse_cursor = nil
        @lower_pad = nil
        @scene = Scene.new
        initialize_area
        @clip_scene = @scene.new_scene
        @clip_area = @clip_scene.new_rectangle at: false, fill: false
        @pads = []
        @layout = nil
        @pads_layout = Pads.layout
      end

      def to_s
        "\x1e#{object_id}\x1e"
      end

      def initialize_area
        @area = @scene.new_rectangle scenic: false
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
        @clip_scene.set_clip @clip_area
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
        e.close if keyboardy && keyboard_request
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
        if !e.drag && include_point(*layer.translate(*e.xy, self))
          report MouseButtonClickEvent.new e
        end
        e.close
      end

      def focus_enter e
      end

      def focus_leave e
      end

      def update_subject subject
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

      def area_size_x
        @area.size_x
      end

      def area_size_y
        @area.size_y
      end

      def area_size
        [area_size_x, area_size_y]
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
      
      def clip_size_x
        @clip_area.size_x
      end

      def clip_size_y
        @clip_area.size_y
      end

      def clip_size
        [clip_size_x, clip_size_y]
      end

      attr :lower_pad, :clip_scene, :pads

      def scene &block
        @scene.set &block if block
        @scene
      end

      def lower_pad_iterator include_self = true
        Enumerator.new do |e|
          pad = include_self ? self : lower_pad
          while pad && !pad.is(Pane)
            e << pad
            pad = pad.lower_pad
          end
        end
      end

      def in_pad pad
        lower_pad_iterator.include? pad
      end

      def pad_detach transfer = false
        @scene.detach
        if @lower_pad
          @lower_pad.remove_pad self, transfer
          @lower_pad = nil
          grand_detach
        end
      end

      def pad_index
        lower_pad&.pads.index self
      end

      def put_pad pad, at = nil
        case at
        when Integer
          paint_state = @clip_scene.put_paint pad.scene, false
          @pads.insert at, pad
        when Pad
          paint_state = @clip_scene.put_paint pad.scene, false, at.scene
          @pads.insert @pads.index(at), pad
        else
          paint_state = @clip_scene.put_paint pad.scene, false
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

      def update_xy x, y
        @scene.set_xy x.floor, y.floor
      end

      def get_x clip_size, size, ax
        case @x
        when Rational
          @x * clip_size - size * 0.5
        when Proc
          @x[clip_size, size]
        when Range
          ax + @x.begin
        when Start
          0
        when Center
          (clip_size - size) * 0.5
        when End
          clip_size - size
        when Auto
          ax
        when Numeric
          @x
        else raise_is @x
        end
      end

      def get_y clip_size, size, ay
        case @y
        when Rational
          @y * clip_size - size * 0.5
        when Proc
          @y[clip_size, size]
        when Range
          ay + @y.begin
        when Start
          0
        when Center
          (clip_size - size) * 0.5
        when End
          clip_size - size
        when Auto
          ay
        when Numeric
          @y
        else raise_is @y
        end
      end

      def update_size x, y
        margin_x = @margin_xs + @margin_xe
        margin_y = @margin_ys + @margin_ye
        @area.set_size x.floor, y.floor
        @scene.set_pivot x * 0.5, y * 0.5
        @clip_area.set_size (x - margin_x).floor, (y - margin_y).floor
      end

      def pads_layoutic
        pads.filter{|it| it.layoutic }
      end

      def arranged_pads
        pads
      end

      def arrange
        @pads_layout.arrange self
      end

      def fit_size_x
        @margin_xs + @margin_xe + @pads_layout.fit_size_x(self)
      end

      def min_size_x
        margin = @margin_xs + @margin_xe
        value = min_size_x_value margin
        value = [value, min_size_x_limit(@size_x_limit, margin)].max if @size_x_limit
        value
      end

      def min_size_x_value margin
        size_x = case @size_x
        when Rational, Proc
          margin
        when Fit
          fit_size_x
        when Auto
          @area.size_x
        when :y
          get_size_y
        when Numeric
          @size_x < 0 ? margin : @size_x
        else
          raise_is @size_x
        end
      end

      def min_size_x_limit limit, margin
        case limit
        when Fit
          fit_size_x
        when Auto
          @area.size_x
        when Numeric
          limit < 0 ? margin : limit
        when Range
          min_size_x_limit limit.begin, margin
        else
          margin
        end
      end

      def get_size_x reference_size_x = nil, size_y = nil
        get_size_x_limited @size_x, @size_x_limit, reference_size_x, size_y
      end

      def get_size_x_limited size_x, limit, reference_size_x, size_y = nil
        value = get_size_x_value size_x, reference_size_x, size_y
        case limit
        when nil
          value
        when Range
          value = [value, get_size_x_value(limit.begin, reference_size_x, size_y)].max if limit.begin
          value = [value, get_size_x_value(limit.end, reference_size_x, size_y)].min if limit.end
          value
        else
          [value, get_size_x_value(limit, reference_size_x, size_y)].min
        end
      end

      def get_size_x_rational pad, rational, reference_size_x
        @pads_layout.get_size_x_rational self, reference_size_x, pad, rational
      end

      def get_size_x_value size_x, reference_size_x, size_y
        case size_x
        when Rational
          @lower_pad.get_size_x_rational self, size_x, reference_size_x || @lower_pad.get_size_x
        when Proc
          size_x[reference_size_x || @lower_pad.get_size_x]
        when Fit
          fit_size_x
        when Auto
          @area.size_x
        when :y
          size_y || get_size_y
        when Numeric
          size_x < 0 ? (reference_size_x || @lower_pad.get_size_x) + size_x : size_x
        else
          raise_ia size_x
        end
      end

      def fit_size_y
        @margin_ys + @margin_ye + @pads_layout.fit_size_y(self)
      end

      def min_size_y
        margin = @margin_ys + @margin_ye
        value = min_size_y_value margin
        value = [value, min_size_y_limit(@size_y_limit, margin)].max if @size_y_limit
        value
      end

      def min_size_y_value margin
        case @size_y
        when Rational, Proc
          margin
        when Fit
          fit_size_y
        when Auto
          @area.size_y
        when :x
          get_size_x
        when Numeric
          @size_y < 0 ? margin : @size_y
        else
          raise_is @size_y
        end
      end

      def min_size_y_limit limit, margin
        case limit
        when Fit
          fit_size_y
        when Auto
          @area.size_y
        when Numeric
          limit < 0 ? margin : limit
        when Range
          min_size_y_limit limit.begin, margin
        else
          margin
        end
      end

      def get_size_y reference_size_y = nil, size_x = nil
        get_size_y_limited @size_y, @size_y_limit, reference_size_y, size_x
      end

      def get_size_y_limited size_y, limit, reference_size_y, size_x = nil
        value = get_size_y_value size_y, reference_size_y, size_x
        case limit
        when nil
          value
        when Range
          value = [value, get_size_y_value(limit.begin, reference_size_y, size_x)].max if limit.begin
          value = [value, get_size_y_value(limit.end, reference_size_y, size_x)].min if limit.end
          value
        else
          [value, get_size_y_value(limit, reference_size_y, size_x)].min
        end
      end

      def get_size_y_rational pad, rational, reference_size_y
        @pads_layout.get_size_y_rational self, reference_size_y, pad, rational
      end

      def get_size_y_value size_y, reference_size_y, size_x
        case size_y
        when Rational
          @lower_pad.get_size_y_rational self, size_y, reference_size_y || @lower_pad.get_size_y
        when Proc
          size_y[reference_size_y || @lower_pad.get_size_y]
        when Fit
          fit_size_y
        when Auto
          @area.size_y
        when :w
          size_x || get_size_x
        when Numeric
          size_y < 0 ? (reference_size_y || @lower_pad.get_size_y) + size_y : size_y
        else
          raise_ia size_y
        end
      end

      def update_margin
        x = @margin_xs.floor
        y = @margin_ys.floor
        @clip_scene.set_xy x, y
        @clip_area.set_xy x, y
      end

      def update_scenic scenic
        displayed_before = displayed
        @scene.update_scenic scenic
        displayed_after = displayed
        if displayed_before != displayed_after
          if displayed_after
            report ShowEvent.new, false
            @pads.each &:show_propagate
          else
            report HideEvent.new, false
            @pads.each &:hide_propagate
          end
        end
      end

      def get_scenic
        @scene.scenic
      end

      def show_propagate
        if scenic
          report ShowEvent.new, false
          @pads.each &:show_propagate
        end
      end

      def hide_propagate
        if scenic
          report HideEvent.new, false
          @pads.each &:hide_propagate
        end
      end

      def point_pads x, y, pads, force = false
        if force || (mousy && scenic && include_point(x, y))
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
        layer.update_keyboard_pad if keyboard_in
      end

      def check_mouse_in pad
        is pad or find_lower pad
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

      def request_vision x = 0, y = 0
        report VisionOfferEvent.new *area_size, x, y
      end

      def translate x = 0, y = 0, target = nil
        lower = lower_pad
        case target
        when self
        when nil
          return lower.translate x + sx, y + sy, false if lower
        when false
          return lower.translate x + sx + cx, y + sy + cy, false if lower
        else
          xy = lower.translate x + sx + cx, y + sy + cy
          xy = target.translate -xy[0], -xy[1]
          return [-xy[0], -xy[1]]
        end
        return [x, y]
      end

      def report event, path = true, instant = false
        super(event, path == true ? lower_pad_iterator.to_a.reverse : path, instant)
      end

      def c_set_lower at
        return if @lower_pad
        pad = @lower.is(Pad) || @lower.find_lower(Pad)
        pad_attach pad, at
      end

      def pad_attach lower, at
        @lower_pad = lower
        @lower_pad&.put_pad self, at
      end

      def default_text text
        put TextPad, text
      end
    end
  end
end