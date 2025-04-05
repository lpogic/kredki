require_relative 'pad_event_manager'
require_relative 'pad_events'
require_relative 'pad_base'
require_relative 'pad_inherited'
require 'forwardable'
require 'kredki-core/context/context'
require 'kredki-core/flagship'
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
          use! arg
        else
          raise "Unsupported << (#{arg} : #{arg.class})"
        end
        self
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

      param def name! name
        @names[name] = true
      end, get: false

      def names
        @names
      end

      def_flag :keyboardy
      
      attr :parent, :action, :scene, :clip_area, :clip_scene, :pads

      alias_method :a, :action

      def s
        self
      end

      def_delegators :@scene,
        :show?, :show!, :show=,
        :x, :y, :xy

      vparam def area! area
        @area != area and begin
          area.wh! *@area.wh
          @scene.push_paint area, true, @area
          @scene.remove_paint @area
          @area = area
          true
        end
      end

      vparam def layout! layout, ...
        layout = layout.new.alter(...) if layout.is_a? Class
        @layout != layout and begin
          @layout = layout
          arrange
          layer&.update_mouse_location if mousy? && show?
          true
        end
      end

      def include_point? x, y
        @area.contain? x, y
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

      vparam def x! x
        neqr @x, x and set_xy x, @y
      end, get: false

      vparam def y! y
        neqr @y, y and set_xy @x, y
      end, get: false

      vparam def xy! x, y = nil
        y ||= x
        neqr @x, x or neqr @y, y and set_xy x, y
      end, get: false, parts: [:x, :y]

      vparam def me! me
        neqr @me, me and set_margin me, @mn, @mw, @ms
      end, :margin_east

      vparam def mn! mn
        neqr @mn, mn and set_margin @me, mn, @mw, @ms
      end, :margin_north

      vparam def mw! mw
        neqr @mw, mw and set_margin @me, @mn, mw, @ms
      end, :margin_west

      vparam def ms! ms
        neqr @ms, ms and set_margin @me, @ms, @mw, ms
      end, :margin_south

      param def mx! me, mw = nil
        mw ||= me
        neqr @me, me or neqr @mw, mw and set_margin me, @mn, mw, @ms
      end, :margin_x, get: false

      param def my! mn, ms = nil
        ms ||= mn
        neqr @mn, mn or neqr @ms, ms and set_margin @me, mn, @mw, ms
      end, :margin_y, get: false

      param def m! me, mn = nil, mw = nil, ms = nil
        mn ||= me
        mw ||= me
        ms ||= mn
        neqr @me, me or neqr @mw, mw or neqr @mn, mn or neqr @ms, ms and set_margin me, mn, mw, ms
      end, :margin, get: false

      def neqr a, b
        a != b or (Rational === a) != (Rational === b)
      end

      param def w! w
        neqr @w, w and set_size w, @h
      end, :width

      param def h! h
        neqr @h, h and set_size @w, h
      end, :height

      param def wh! w, h = nil
        h ||= w
        (neqr @w, w) || (neqr @h, h) and set_size w, h
      end, :size, get: false
      
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

      def pw
        @me + @mw + (@pads.first&.pw || 0)
      end

      def ph
        @mn + @ms + (@pads.first&.ph || 0)
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

      def use! extension, *a, **na, &b
        extension.plug_into self, *a, **na, &b if extension.respond_to? :plug_into
      end

      param_prefix :stroke
    
      vparam def color! *color
        case color
        in [false]
          area.hide!
        else
          area.show!
          area.color! *color
        end
      end, get: false

      def roi!
        report ROIEvent.new *wh, *translate
      end

      def_delegators :@area,
        :h, :height, 
        :w, :width,
        :wh, :size,
        :color

      defd_param :@area, :blunt, :stroke_width, :stroke_color, :stroke_join, :stroke_cap

      #internal api

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
        @vparams = {}
        @pads = []
        @button_down_xy = nil
        @x = @y = :auto
        @w = @h = 100
        @me = @mn = @mw = @ms = 0
        @layout = Layout::INSTANCE
      end

      def sketch p0
        on_mouse_enter!{ mouse_enter _1 }
        on_mouse_leave!{ mouse_leave _1 }
        on_mouse_button!{ mouse_button_down _1 }
        on_mouse_button_up!{ mouse_button_up _1 }
        on_mouse_move!{ mouse_move _1 }
        on_resize!{ resize _1 }
      end

      def mouse_button_down e
        p e.button
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
        resize_arrange
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
        resize_arrange
        event_director.stem do
          layer.update_mouse_location
        end if mousy? && mouse_in? || pad.mousy? && pad.mouse_in?
        pad
      end

      def remove_pad pad, transfer
        removed = @pads.delete pad
        if removed && !transfer
          pad.scene.clip! false
          resize_arrange
          event_director.stem do
            layer.update_mouse_location
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
          resize_arrange
          event_director.stem do
            layer.update_mouse_location
          end if mousy? && mouse_in?
        end
      end
      
      def set_size w, h
        @w = w
        @h = h
        update_size true
      end

      def update_size update_mouse_pad = false
        set_size_impl and event_director.stem do
          report ResizeEvent.new
          update_xy and report MoveEvent.new
          layer&.update_mouse_location if update_mouse_pad && mousy? && show?
          true
        end
      end

      def set_xy x, y
        @x = x
        @y = y
        update_xy and event_director.stem do
          report MoveEvent.new
          layer&.update_mouse_location if mousy? && show?
          true
        end
      end

      def set_margin e, n, w, s
        @me = e
        @mn = n
        @mw = w
        @ms = s
        update_margin and event_director.stem do
          layer&.update_mouse_location if mousy? && show?
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
        when :fit
          @layout.fit_w self
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
        when :fit
          @layout.fit_h self
        else
          if @h < 0
            ph = parent&.ch || 0
            ph + @h
          else
            @h
          end
        end

        ((area.wh! sw, sh) | (@clip_area.wh! sw - mx, sh - my)) and arrange
      end

      def update_xy ax = nil, ay = nil
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
        when :auto
          ax || @scene.x
        else
          @x
        end

        sy = case @y
        when Rational 
          r = (ph - sh) * @y.to_f
          @y.denominator == 1 ? r / 100 : r
        when Proc
          @y[ph, sh]
        when :auto
          ay || @scene.y
        else
          @y
        end

        @scene.xy! sx, sy
      end

      def update_margin
        (@clip_scene.xy! @me, @mn) | (@clip_area.wh! w - @me - @mw, h - @mn - @ms and arrange)
      end

      def arrange
        return if altered? :arrange
        @layout.arrange self
      end

      def resize_arrange
        return if altered? :resize_arrange
        @w == :fit || @h == :fit and update_size or arrange
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
            return pa.translate x + self.x, y + self.y, false
          end
        when false
          if pa = parent
            return pa.translate x + self.cx, y + self.cy, false
          end
        else
          xy = parent.translate x + self.cx, y + self.cy
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
        return if @parent == parent
        @parent = parent
        set_action parent&.action
        update_size true
      end

      def set_action action
        return if @action == action
        @action = action
        @pads.each{ _1.set_action action }
      end
    end
  end
end