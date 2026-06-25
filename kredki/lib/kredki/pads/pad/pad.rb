require_relative 'pad_events'

module Kredki
  module Pads
    # Base class of visible Pads tree nodes.
    class Pad < Service
      include PadEvents

      feature :subject

      def set_subject subject = @subject
        return if @subject == subject
        @subject = subject
        update_subject subject
        true
      end
      
      def subject
        @subject
      end

      feature :x # Position along the X axis.

      def set_x x = @x, &block
        x = block if block_given?
        return if Util.eqr @x, x
        @x = x
        layer&.break_layout
        true
      end
      
      def x
        @x
      end

      feature :y # Position along the Y axis.

      def set_y y = @y, &block
        y = block if block_given?
        return if Util.eqr @y, y
        @y = y
        layer&.break_layout
        true
      end

      def y
        @y
      end

      feature :xy # Position along X and Y axes.

      def set_xy x, y = x
        return if (Util.eqr @y, y) && (Util.eqr @x, x)
        @x = x
        @y = y
        layer&.break_layout
        true
      end
      
      def xy
        [@x, @y]
      end

      feature :size_x # Size in the X axis.

      def set_size_x size_x = @size_x, **ka, &block
        size_x = block if block_given?
        change = unless Util.eqr @size_x, size_x
          @size_x = size_x
          layer&.break_layout
          true
        end
        nest_set(__method__, ka) || change
      end

      def size_x
        @size_x
      end

      feature :size_y # Size in the Y axis.
      
      def set_size_y size_y = @size_y, **ka, &block
        size_y = block if block_given?
        change = unless Util.eqr @size_y, size_y
          @size_y = size_y
          layer&.break_layout
          true
        end
        nest_set(__method__, ka) || change
      end

      def size_y
        @size_y
      end

      feature :size
      
      def set_size size_x = @size_x, size_y = size_x, **ka
        change = unless Util.eqr(@size_x, size_x) && Util.eqr(@size_y, size_y)
          @size_x = size_x
          @size_y = size_y
          layer&.break_layout
          true
        end
        nest_set(__method__, ka) || change
      end

      def size
        [@size_x, @size_y]
      end

      feature :size_x_limit # Size limit in the X axis.

      def set_size_x_limit size_x_limit
        raise_ia size_x_limit, "Rational limit disabled." if Rational === size_x_limit
        return if @size_x_limit = size_x_limit
        @size_x_limit = size_x_limit
        layer&.break_layout
        true
      end

      def size_x_limit
        @size_x_limit
      end

      feature :size_y_limit # Size limit in the Y axis.
      
      def set_size_y_limit size_y_limit
        raise_ia size_y_limit, "Rational limit disabled." if Rational === size_y_limit
        return if @size_y_limit = size_y_limit
        @size_y_limit = size_y_limit
        layer&.break_layout
        true
      end

      def size_y_limit
        @size_y_limit
      end

      feature :size_limit
      
      def set_size_limit x_limit, y_limit = x_limit
        set_size_x_limit(x_limit) | set_size_y_limit(y_limit)
      end

      def size_limit
        [@size_x_limit, @size_y_limit]
      end

      feature :margin_xs # X start margin.

      def set_margin_xs m
        return if Util.eqr @margin_xs, m
        @margin_xs = m
        layer&.break_layout
        true
      end
      
      def margin_xs
        @margin_xs
      end

      feature :margin_xe # X end margin.
      
      def set_margin_xe m
        return if Util.eqr @margin_xe, m
        @margin_xe = m
        layer&.break_layout
        true
      end

      def margin_xe
        @margin_xe
      end

      feature :margin_ys # Y start margin.
      
      def set_margin_ys m
        return if Util.eqr @margin_ys, m
        @margin_ys = m
        layer&.break_layout
        true
      end

      def margin_ys
        @margin_ys
      end

      feature :margin_ye # Y end margin.

      def set_margin_ye m
        return if Util.eqr @margin_ye, m
        @margin_ye = m
        layer&.break_layout
        true
      end

      def margin_ye
        @margin_ye
      end

      feature :margin_x # X start and X end margin.

      def set_margin_x margin_xs, margin_xe = margin_xs
        return if (Util.eqr @margin_xs, margin_xs) && (Util.eqr @margin_xe, margin_xe)
        @margin_xs = margin_xs
        @margin_xe = margin_xe
        layer&.break_layout
        true
      end

      def margin_x
        [@margin_xs, @margin_xe]
      end

      feature :margin_y # Y start and Y end margin.
      
      def set_margin_y margin_ys, margin_ye = margin_ys
        return if (Util.eqr @margin_ys, margin_ys) && (Util.eqr @margin_ye, margin_ye)
        @margin_ys = margin_ys
        @margin_ye = margin_ye
        layer&.break_layout
        true
      end
      
      def margin_y
        [@margin_ys, @margin_ye]
      end

      feature :margin # Margin feature nest.

      def set_margin margin_xs = @margin_xs, margin_ys = margin_xs, margin_xe = margin_xs, margin_ye = margin_ys, **ka
        change = unless (Util.eqr @margin_xs, margin_xs) && (Util.eqr @margin_xe, margin_xe) && (Util.eqr @margin_ys, margin_ys) && (Util.eqr @margin_ye, margin_ye)
          @margin_xs = margin_xs
          @margin_xe = margin_xe
          @margin_ys = margin_ys
          @margin_ye = margin_ye
          layer&.break_layout
          true
        end
        nest_set(__method__, ka) || change
      end
      
      def margin
        [@margin_xs, @margin_ys, @margin_xe, @margin_ye]
      end

      feature :margin_clip # Whether the clip area is reduced by the margins.

      def set_margin_clip value = true
        return if (c = margin_clip) == (value = value == Not ? !c : value)
        @margin_clip_not = !value
        layer&.break_layout
        true
      end

      def margin_clip
        !@margin_clip_not
      end

      feature :layout_spacer # Spacer between pads arranged with selected layout (if the layout respects spacing).
      
      def set_layout_spacer layout_spacer
        return if Util.eqr @layout_spacer, layout_spacer
        @layout_spacer = layout_spacer
        layer&.break_layout
        true
      end
      
      def layout_spacer
        @layout_spacer
      end

      feature :turn # Turn around the pivot point.

      def set_turn turn
        return if @turn == turn
        @turn = turn
        @scene.set_turn turn
      end
      
      def turn
        @turn
      end

      feature :zoom_x # Zoom in the X axis.

      def set_zoom_x ...
        @scene.set_zoom_x(...)
      end
      
      def zoom_x
        @scene.zoom_x
      end

      feature :zoom_y # Zoom in the Y axis.
      
      def set_zoom_y ...
        @scene.set_zoom_y(...)
      end
      
      def zoom_y
        @scene.zoom_y
      end

      feature :zoom # Zoom in X and Y axes.

      def set_zoom ...
        @scene.set_zoom(...)
      end
      
      def zoom
        @scene.zoom
      end

      feature :opacity
      
      def set_opacity opacity
        return if @opacity == opacity
        @opacity = opacity
        opacity *= 255 if opacity.is_a? Rational
        @scene.set_opacity opacity
      end

      def opacity
        @opacity
      end

      feature :mouse_cursor # Mouse cursor when pad is mouse top.

      def set_mouse_cursor mouse_cursor
        return if @mouse_cursor == mouse_cursor
        @mouse_cursor = mouse_cursor
        pane&.mouse_stale = true
        true
      end
      
      def mouse_cursor
        @mouse_cursor
      end

      feature :area

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
          a.attach @scene, @area
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
      
      def area
        @area
      end

      feature :clip_area

      # [Create] and attach clip area.
      def set_clip_area area = nil, &block
        a = Class === area ? area.new(&block) : area
        return if @clip_area == a
        a.set **@clip_area, filter_keywords: true
        @clip_scene.set_clip a
        @clip_area = a
        true
      end

      def clip_area
        @clip_area
      end

      feature :layout
      
      def set_layout *a, **ka
        changes = a.count do |it|
          case it
          when Numeric
            set_layout_spacer it
          else
            update_layout it
          end
        end
        nest_set(__method__, ka) || changes > 0
      end

      def layout
        @layout
      end

      feature :scenic # Whether Pad is scenic. All lower pads must also be scenic for the Pad to be displayed.

      def set_scenic value = true
        return if (c = scenic) == (value = value == Not ? !c : value)
        update_scenic value
        true
      end

      def scenic
        @scene.scenic
      end

      # Get whether Pad is displayed
      def displayed
        @scene.displayed
      end

      feature :layoutic # Whether Pad is layoutic. Layoutic pad occupy place in layout even if it is not scenic.

      def set_layoutic value = true
        return if (c = layoutic) == (value = value == Not ? !c : value)
        layer&.break_layout
        @layoutic = value
        true
      end
      
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

      feature :keyboardy # Whether Pad can be keyboard events target.

      def set_keyboardy value = true
        return if (c = keyboardy) == (value = value == Not ? !c : value)
        @keyboardy = value
        true
      end

      def keyboardy
        @keyboardy
      end
      
      feature :mousy # Whether Pad can be mouse events target.

      def set_mousy value = true
        return if (c = mousy) == (value = value == Not ? !c : value)
        @mousy = value
        true
      end
      
      def mousy
        @mousy || @mousy.nil?
      end

      feature :disabled
      
      def set_disabled value = true
        return if (c = disabled) == (value = value == Not ? !c : value)
        @disabled = value
        repaint
        true
      end
      
      def disabled
        @disabled
      end

      # Get whether self or any lower is disabled.
      def in_disabled
        disabled || lower(Pad){|it| it.disabled }
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
              pad = direct_upper{|c| c.object_id == id }
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
      def detach transfer = false, system_call = false
        super
        pad_detach transfer
      end

      def mixed_set feature
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

      def area_x
        @scene.x
      end

      def area_y
        @scene.y
      end

      def area_xy
        [area_x, area_y]
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

      def clip_x
        @clip_scene.x
      end

      def clip_y
        @clip_scene.y
      end

      def clip_xy
        [clip_x, clip_y]
      end
      
      def clip_size_x
        if @margin_clip_not
          @area.size_x
        else
          @area.size_x - @margin_xs - @margin_xe
        end
      end

      def clip_size_y
        if @margin_clip_not
          @area.size_y
        else
          @area.size_y - @margin_ys - @margin_ye
        end
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
          @lower_pad.delete_pad self, transfer
          @lower_pad = nil
          lower_pad_detached
        end
      end

      def pad_index
        lower_pad&.pads.index self
      end

      def put_pad pad, at = nil
        case at
        when Integer
          @clip_scene.put_paint pad.scene
          @pads.insert [at, @pads.size].min, pad
        when Pad
          @clip_scene.put_paint pad.scene, at.scene
          @pads.insert @pads.index(at), pad
        else
          @clip_scene.put_paint pad.scene
          @pads << pad
        end
        layer&.break_layout
        pad
      end

      def delete_pad pad, transfer
        deleted = @pads.delete pad
        if deleted
          layer&.break_layout
        end
        deleted
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
        when :end_center
          clip_size - size * 0.5
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
        when :end_center
          clip_size - size * 0.5
        else raise_is @y
        end
      end

      def update_size x, y
        margin_x = @margin_xs + @margin_xe
        margin_y = @margin_ys + @margin_ye
        change = @area.set_size x.floor, y.floor
        @scene.set_pivot x * 0.5, y * 0.5
        if @margin_clip_not
          change = (@clip_area.set_size x.floor, y.floor) || change
        else
          change = (@clip_area.set_size (x - margin_x).floor, (y - margin_y).floor) || change
        end
        change
      end

      def layoutic_pads
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

      def get_size_x_rational pad, rational
        @pads_layout.get_size_x_rational self, get_size_x, pad, rational
      end

      def get_size_x_value size_x, reference_size_x, size_y
        case size_x
        when Rational
          if reference_size_x
            reference_size_x * size_x
          else
            @lower_pad.get_size_x_rational self, size_x
          end
        when Proc
          size_x[reference_size_x || @lower_pad.get_size_x]
        when Fit
          fit_size_x
        when Auto
          @area.size_x
        when :y
          size_y || get_size_y
        when :y_2
          (size_y || get_size_y) * 0.5
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

      def get_size_y_rational pad, rational
        @pads_layout.get_size_y_rational self, get_size_y, pad, rational
      end

      def get_size_y_value size_y, reference_size_y, size_x
        case size_y
        when Rational
          if reference_size_y
            reference_size_y * size_y
          else
            @lower_pad.get_size_y_rational self, size_y
          end
        when Proc
          size_y[reference_size_y || @lower_pad.get_size_y]
        when Fit
          fit_size_y
        when Auto
          @area.size_y
        when :x
          size_x || get_size_x
        when Numeric
          size_y < 0 ? (reference_size_y || @lower_pad.get_size_y) + size_y : size_y
        else
          raise_ia size_y
        end
      end

      def update_margin
        if @margin_clip_not
          @clip_scene.set_xy 0, 0
          @clip_area.set_xy 0, 0
        else
          x = @margin_xs.floor
          y = @margin_ys.floor
          @clip_scene.set_xy x, y
          @clip_area.set_xy x, y
        end
      end

      def update_scenic scenic
        displayed_before = displayed
        @scene.set_scenic scenic
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
          @pads.reverse_each.find{ _1.point_pads x - _1.area_x, y - _1.area_y, pads }
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
        is pad or lower pad
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
          return lower.translate x + area_x, y + area_y, false if lower
        when false
          return lower.translate x + area_x + clip_x, y + area_y + clip_y, false if lower
        else
          xy = lower.translate x + area_x + clip_x, y + area_y + clip_y
          xy = target.translate -xy[0], -xy[1]
          return [-xy[0], -xy[1]]
        end
        return [x, y]
      end

      def translate_x x, target = nil
        lower = lower_pad
        case target
        when self
        when nil
          return lower.translate_x x + area_x, false if lower
        when false
          return lower.translate_x x + area_x + clip_x, false if lower
        else
          tx = lower.translate_x x + area_x + clip_x
          return -target.translate(-tx)
        end
        return x
      end

      def translate_y y, target = nil
        lower = lower_pad
        case target
        when self
        when nil
          return lower.translate_y y + area_y, false if lower
        when false
          return lower.translate_y y + area_y + clip_y, false if lower
        else
          ty = lower.translate_y y + area_y + clip_y
          return -target.translate(-ty)
        end
        return y
      end

      def report event, path = true, instant = false
        super(event, path == true ? lower_pad_iterator.to_a.reverse : path, instant)
      end

      def c_set_lower at
        return if @lower_pad
        pad = @lower.is(Pad) || @lower.lower(Pad)
        pad_attach pad, at
      end

      def pad_attach lower, at
        @lower_pad = lower
        @lower_pad&.put_pad self, at
      end

      def update_layout layout = nil
        return if @layout == layout
        @layout = layout
        pads_layout = Pads.layout layout
        return true if @pads_layout == pads_layout
        @pads_layout = pads_layout
        layer&.break_layout
        true
      end

      def default_text text
        put TextPad, text
      end
    end
  end
end