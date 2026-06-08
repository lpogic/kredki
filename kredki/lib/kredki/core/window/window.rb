module Kredki
  class Window

    # Show a window.
    def show
      Pastele.window_show @pointer
    end

    # Hide a window.
    def hide
      Pastele.window_hide @pointer
    end

    # Maximize a window.
    def maximize
      Pastele.window_maximize @pointer
    end

    # Minimize a window.
    def minimize
      Pastele.window_minimize @pointer
    end

    # Request that a window be raised above other windows and gain the input focus.
    def focus
      Pastele.window_focus @pointer
    end

    # Request that the size and position of a minimized or maximized window be restored.
    def restore
      Pastele.window_restore @pointer
    end

    feature :stroke # Whether the window has an stroke.

    def set_stroke value = true
      return if (c = stroke) == (value = value == Not ? !c : value)
      Pastele.window_set_bordered @pointer, value ? 1 : 0
      true
    end
    
    def stroke
      Pastele.window_get_flags(@pointer) & 0x10 == 0
    end

    feature :fullscreen # Whether fullscreen mode is on.

    def set_fullscreen value = true
      return if (c = fullscreen) == (value = value == Not ? !c : value)
      Pastele.window_set_fullscreen @pointer, value ? 1 : 0
      true
    end
    
    def fullscreen
      Pastele.window_get_flags(@pointer) & 0x1000 != 0
    end

    feature :text_input # Whether text input mode is on.

    def set_text_input value = true
      return if (c = text_input) == (value = value == Not ? !c : value)
      Pastele.window_set_text_input @pointer, value ? 1 : 0
      true
    end
    
    def text_input
      Pastele.window_get_text_input(@pointer) != 0
    end

    feature :opacity
    
    def set_opacity opacity
      return if @opacity == opacity
      Pastele.window_set_opacity @pointer, opacity > 1 ? opacity / 255.0 : opacity
      @opacity = opacity
      true
    end

    def opacity
      @opacity
    end

    feature :xy # Position along X and Y axes.

    def set_xy x = 0, y = x
      x = case x
      when Start
        0
      when Center
        (display_size[0] - size[0]) * 0.5
      when End
        display_size[0] - size[0]
      when Numeric
        x
      else raise_ia x
      end

      y = case y
      when Start
        0
      when Center
        (display_size[1] - size[1]) * 0.5
      when End
        display_size[1] - size[1]
      when Numeric
        y
      else raise_ia y
      end

      Pastele.window_set_position @pointer, x, y
      true
    end
    
    def xy
      point = Pastele::IntPoint.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_position @pointer, point
      [point.x, point.y]
    end

    feature :size
    
    def set_size size_x = 400, size_y = size_x, **ka
      size_x = case size_x
      when Rational
        display_size[0] * size_x
      when Numeric
        size_x
      else raise_ia size_x
      end

      size_y = case size_y
      when Rational
        display_size[1] * size_y
      when Numeric
        size_y
      else raise_ia size_y
      end
      
      Pastele.window_set_size @pointer, size_x, size_y
      nest_set(__method__, ka)
      report ResizeEvent.new size_x, size_y
      true
    end
    
    def size
      point = Pastele::IntPoint.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_size @pointer, point
      [point.x, point.y]
    end

    # Get size in X axis.
    def size_x
      size[0]
    end

    # Get size in Y axis.
    def size_y
      size[1]
    end

    feature :size_limit
    
    def set_size_limit x, y = x
      x_min, x_max = parse_limit x
      y_min, y_max = parse_limit y
      p [x_min, y_min, x_max, y_max]
      Pastele.window_set_minimum_size @pointer, x_min, y_min
      Pastele.window_set_maximum_size @pointer, x_max, y_max
      true
    end
    
    def size_limit
      point = Pastele::IntPoint.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_minimum_size @pointer, point
      x_min, y_min = [point.x, point.y]
      Pastele.window_get_maximum_size @pointer, point
      [x_min..point.x, y_min..point.y]
    end

    feature :resizable # Whether a window width and height can be customized by dragging its border.

    def set_resizable value = true
      return if (c = resizable) == (value = value == Not ? !c : value)
      Pastele.window_set_resizable @pointer, value ? 1 : 0
      true
    end
    
    def resizable
      Pastele.window_get_flags(@pointer) & 0x20 != 0
    end

    feature :title
    
    def set_title title
      Pastele.window_set_title @pointer, title.to_s
      true
    end
    
    def title
      title = Pastele.window_get_title @pointer
      title.to_s.force_encoding "utf-8"
    end

    feature :top # Whether window is always in the foreground.

    def set_top value = true
      return if (c = top) == (value = value == Not ? !c : value)
      Pastele.window_set_always_on_top @pointer, value ? 1 : 0
      true
    end
    
    def top
      Pastele.window_get_flags(@pointer) & 0x10000 != 0
    end
    
    # Get mouse pointer position relative to the window [0, 0].
    def mouse_xy
      x, y = Kredki.mouse.xy
      wx, wy = window.xy
      [x - wx, y - wy]
    end

    feature :mouse_grab # Whether mouse pointer is confined to the window.

    def set_mouse_grab value = true
      return if (c = mouse_grab) == (value = value == Not ? !c : value)
      Pastele.window_set_mouse_mouse_grab @pointer, value ? 1 : 0
      true
    end
    
    def mouse_grab
      Pastele.window_get_mouse_grab(@pointer) != 0
    end

    feature :mouse_relative # Whether relative mouse mode is on.

    def set_mouse_relative value = true
      return if (c = relative) == (value = value == Not ? !c : value)
      Pastele.window_set_mouse_relative_mode @pointer, value ? 1 : 0
      true
    end
    
    def mouse_relative
      Pastele.window_get_mouse_relative_mode(@pointer) != 0
    end
    
    # Get whether mouse pointer is in window.
    def mouse_in
      @mouse_in.nil? ? Kredki.mouse.get_cursor_position != [0, 0] : @mouse_in
    end

    # Get whether capture mode is on.
    def mouse_capture
      Pastele.window_get_flags(@pointer) & 0x4000 != 0
    end
    
    feature :pane
    
    def set_pane pane = default_pane
      case pane
      when Class
        set_pane pane.new
      when String
        pane_service = set_pane
        pane_service.set{ eval File.read pane }
      when Pane
        update_pane pane
        pane.context_service
      else raise_ia pane
      end
    end
    
    def pane
      @pane
    end

    def pane! *a, attach: true, **ka, &b
      pane = default_pane
      if attach
        set_pane(pane).set(*a, **ka, &b)
      else
        pane.window = self
        context = pane.context_service
        pane.set *a, **ka
        context.set &b
      end
      pane
    end

    # Get window (self).
    def window
      self
    end

    def mixed_set feature
      case feature
      when Pane
        set_pane feature
      end
    end

    # Request window close.
    def close
      Pastele.window_close @pointer
    end

    # Get display size.
    def display_size
      bounds = Pastele::Bounds.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_display_bounds @pointer, bounds
      [bounds.w, bounds.h]
    end

    feature :fps_limit
    
    def set_fps_limit fps_limit
      return if @fps_limit == fps_limit
      @fps_limit = fps_limit
      true
    end
    
    def fps_limit
      @fps_limit
    end

    # Save window as PNG image.
    def to_png filepath
      @pane.arrange
      Pastele.window_surface_to_png @pointer, File.expand_path(filepath)
    end

    # Get pixel color.
    def pixel_color x, y
      rg = Pastele::IntPoint.malloc Fiddle::RUBY_FREE
      ba = Pastele::IntPoint.malloc Fiddle::RUBY_FREE
      Pastele.window_get_pixel_color @pointer, x, y, rg, ba
      Kredki.color [rg.x, rg.y, ba.x, ba.y]
    end

    # :section: LEVEL 2

    def initialize *a
      @pointer = default_pointer *a
      @application = nil
      @sketched = false
      @update_thread = nil
      @update_queue = Thread::Queue.new
      @update_timestamp = 0
      @update_error = 0
      @fps_limit = 100
      @expose_timestamp = 0
      @pane = nil
      @mouse_in = nil
      ObjectSpace.define_finalizer(self, Window.finalizer(@pointer))
    end

    def self.finalizer pointer
      proc{ Pastele.window_delete pointer }
    end

    def default_pointer size_x = 400, size_y = 400
      Pastele.window_new_sw size_x, size_y
    end

    def default_pane
      Pane.new
    end
    
    attr :pointer

    def sketch_window
      return if @sketched
      @sketched = true
      sketch
    end

    def sketch
      set_resizable true
      set_text_input true
    end

    def attach application
      @application = application
      sketch_window
      @update_thread = Thread.new do
        loop do
          Pastele.window_update_request window.pointer
          @update_queue.pop&.then{|it| sleep it }
        end
      end
    end

    def detach
      @application = nil
      @update_thread&.kill
      @update_thread = nil
    end

    def application
      @application
    end

    def update_complete event
      if @fps_limit
        @update_queue.push (update_delay (event.timestamp - @update_timestamp) / 1000000000.0, 1.0 / @fps_limit)
      else
        @update_queue.push nil
      end
      @update_timestamp = event.timestamp
    end

    def update_delay last, target
      return target if last > 2 * target
      @update_error += (target - last) * 0.01
      e = target + @update_error
      e < 0 ? target : e
    end

    def report event, ...
      case event
      when UpdateCompleteEvent
        update_complete event
      when WindowExposeEvent
        update = if @fps_limit
          delay = (event.timestamp - @expose_timestamp) / 1000000000.0
          rate_delay = 1.0 / @fps_limit
          delay >= rate_delay
        else true 
        end
        if update
          @expose_timestamp = event.timestamp
          @pane&.report(event, ...)
          Pastele.window_update @pointer, 1
        end
      else
        @pane&.report(event, ...)
      end
    end

    def update_paint paint
      Pastele.window_paint_to_update @pointer, paint.pointer
    end

    def inspect
      "#{self.class}:#{object_id}"
    end

    def update_pane pane, &block
      @pane&.scenic = false
      if pane
        pane.window&.update_pane nil
        pane.window = self
        Pastele.window_set_scene @pointer, pane.pointer
      else
        Pastele.window_set_scene @pointer, nil
      end
      update_paint pane if pane
      @pane = pane
    end

    def update_mouse_in set
      @mouse_in = set
    end

    def get_capture
      Pastele.window_get_flags(@pointer) & 0x4000 != 0
    end

    def parse_limit limit
      case limit
      when Range
        [limit.begin || 0, limit.end || 999999999]
      else
        [0, limit || 999999999]
      end
    end
  end
end