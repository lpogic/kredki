module Kredki
  class Window

    def set_show show = true
      if show
        Pastele.window_show @pointer
      else
        Pastele.window_hide @pointer
      end
    end

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

    # Set whether the window has an outline.
    def set_outline value = true
      return if (c = outline) == (value = block_given? ? yield(c) : value == Not ? !c : value)
      Pastele.window_set_bordered @pointer, value ? 1 : 0
      true
    end

    # See #set_outline.
    def outline= value
      set_outline value
    end
    
    # Get whether the window has an outline.
    def outline
      Pastele.window_get_flags(@pointer) & 0x10 == 0
    end

    # See #outline.
    def outline?
      !!outline
    end

    # Set whether fullscreen mode is on.
    def set_fullscreen value = true
      return if (c = fullscreen) == (value = block_given? ? yield(c) : value == Not ? !c : value)
      Pastele.window_set_fullscreen @pointer, value ? 1 : 0
      true
    end

    # See #set_fullscreen.
    def fullscreen= value
      set_fullscreen value
    end
    
    # Get whether fullscreen mode is on.
    def fullscreen
      Pastele.window_get_flags(@pointer) & 0x1000 != 0
    end

    # See #fullscreen.
    def fullscreen?
      !!fullscreen
    end

    # Set whether text input mode is on.
    def set_text_input value = true
      return if (c = text_input) == (value = block_given? ? yield(c) : value == Not ? !c : value)
      Pastele.window_set_text_input @pointer, value ? 1 : 0
      true
    end

    # See #set_text_input.
    def text_input= value
      set_text_input value
    end
    
    # Get whether text input mode is on.
    def text_input
      Pastele.window_get_text_input(@pointer) != 0
    end

    # See #text_input.
    def text_input?
      !!text_input
    end
        
    # Set opacity.
    def set_opacity opacity = @opacity
      return set_opacity yield self.opacity if block_given?
      return if @opacity == opacity
      Pastele.window_set_opacity @pointer, opacity > 1 ? opacity / 255.0 : opacity
      @opacity = opacity
      true
    end

    # See #set_opacity.
    def opacity= param
      set_opacity param
    end

    # Get opacity.
    def opacity
      @opacity
    end

    # Set position along X and Y axes.
    def set_xy x = 0, y = x
      return send_bundle :set_xy, yield(self.xy) if block_given?
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

    # See #set_xy.
    def xy= param
      send_bundle :set_xy, param
    end
    
    # Get position along X and Y axes.
    def xy
      point = Pastele::IntPoint.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_position @pointer, point
      [point.x, point.y]
    end

    # Set size. 
    def set_size size_x = 400, size_y = size_x, **ka
      return send_bundle :set_size, yield(self.size) if block_given?
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
      ka.each{ send_bundle "size_#{_1}!", _2 }
      report ResizeEvent.new size_x, size_y
      true
    end

    # See #set_size.
    def size= param
      send_bundle :set_size, param
    end

    # Get size.
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

    # Set size limit. 
    def set_size_limit x, y = x
      return send_bundle :set_size_limit, yield(self.size_limit) if block_given?
      x_min, x_max = parse_limit x
      y_min, y_max = parse_limit y
      Pastele.window_set_minimum_size @pointer, x_min, y_min
      Pastele.window_set_maximum_size @pointer, x_max, y_max
      true
    end

    # See #set_size_limit.
    def size_limit= param
      send_bundle :set_size_limit, param
    end

    # Get size limit.
    def size_limit
      point = Pastele::IntPoint.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_minimum_size @pointer, point
      x_min, y_min = [point.x, point.y]
      Pastele.window_get_maximum_size @pointer, point
      [x_min..point.x, y_min..point.y]
    end

    # Set whether a window width and height can be customized by dragging its border.
    def set_resizable value = true
      return if (c = resizable) == (value = block_given? ? yield(c) : value == Not ? !c : value)
      Pastele.window_set_resizable @pointer, value ? 1 : 0
      true
    end

    # See #set_resizable.
    def resizable= param
      set_resizable param
    end

    # Get whether a window width and height can be customized by dragging its border.
    def resizable
      Pastele.window_get_flags(@pointer) & 0x20 != 0
    end

    # See #resizable.
    def resizable?
      !!resizable
    end

    # Set title.
    def set_title title = nil
      return set_title yield self.title if block_given?
      Pastele.window_set_title @pointer, title.to_s
      true
    end

    # See #set_title.
    def title= param
      set_title param
    end

    # Get title.
    def title
      title = Pastele.window_get_title @pointer
      title.to_s.force_encoding "utf-8"
    end

    # Set whether window is always in the foreground.
    def set_top value = true
      return if (c = top) == (value = block_given? ? yield(c) : value == Not ? !c : value)
      Pastele.window_set_always_on_top @pointer, value ? 1 : 0
      true
    end

    # See #set_top.
    def top= param
      set_top param
    end

    # Get whether window is always in the foreground.
    def top
      Pastele.window_get_flags(@pointer) & 0x10000 != 0
    end

    # See #top.
    def top?
      !!top
    end

    # Get mouse pointer position relative to the window [0, 0].
    def mouse_xy
      x, y = Kredki.mouse.xy
      wx, wy = window.xy
      [x - wx, y - wy]
    end

    # Set whether mouse pointer is confined to the window.
    def set_mouse_grab value = true
      return if (c = mouse_grab) == (value = block_given? ? yield(c) : value == Not ? !c : value)
      Pastele.window_set_mouse_mouse_grab @pointer, value ? 1 : 0
      true
    end

    # See #set_mouse_grab.
    def mouse_grab= value
      set_mouse_grab value
    end
    
    # Get whether mouse pointer is confined to the window.
    def mouse_grab
      Pastele.window_get_mouse_grab(@pointer) != 0
    end

    # See #mouse_grab.
    def mouse_grab?
      !!mouse_grab
    end

    # Set whether relative mouse mode is on.
    def set_mouse_relative value = true
      return if (c = relative) == (value = block_given? ? yield(c) : value == Not ? !c : value)
      Pastele.window_set_mouse_relative_mode @pointer, value ? 1 : 0
      true
    end

    # See #set_mouse_relative.
    def mouse_relative= value
      set_mouse_relative value
    end
    
    # Get whether relative mouse mode is on.
    def mouse_relative
      Pastele.window_get_mouse_relative_mode(@pointer) != 0
    end

    # See #mouse_relative.
    def mouse_relative?
      !!mouse_relative
    end

    # Get whether mouse pointer is in window.
    def mouse_in
      @mouse_in.nil? ? Kredki.mouse.get_cursor_position != [0, 0] : @mouse_in
    end

    # See #mouse_in.
    def mouse_in?
      !!mouse_in
    end

    # Get whether capture mode is on.
    def mouse_capture
      Pastele.window_get_flags(@pointer) & 0x4000 != 0
    end

    # See #capture.
    def mouse_capture?
      !!mouse_capture
    end

    # Set and build current pane.
    def set_pane pane = nil, *a, **ka, &b
      case pane
      when Class
        pane = pane.new
        update_pane pane
        pane.service.set(*a, **ka, &b)
      when String
        bc = set_pane Window.default_pane
        bc.set{ eval File.read pane }
        bc.window.set *a, **ka
        bc.set &b
      when nil
        set_pane(Window.default_pane, *a, **ka, &b)
      when Pane
        update_pane pane
        pane.service.set(*a, **ka, &b)
      else # switch or other
        set_pane Window.default_pane, pane, *a, **ka, &b
      end
    end

    # See #set_pane.
    def pane= param
      send_bundle :set_pane, param
    end

    # Get current pane.
    def pane
      @pane
    end

    # Get window (self).
    def window
      self
    end

    def << feature
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

    # Set update rate.
    def set_fps_limit fps_limit = @fps_limit
      return set_fps_limit yield(@fps_limit) if block_given?
      return if @fps_limit == fps_limit
      @fps_limit = fps_limit
      true
    end

    # See #set_fps_limit.
    def fps_limit= param
      send_bundle :set_fps_limit, param
    end

    # Get update rate.
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

    def initialize size_x = 400, size_y = 400, engine: :sw
      @pointer = case engine
      when :sw
        @pointer = Pastele.window_new_sw size_x, size_y
      # when :gl
      #   @pointer = Pastele.window_new_gl size_x, size_y
      else
        raise_ia engine
      end
      @app = nil
      @update_thread = nil
      @update_queue = Thread::Queue.new
      @update_timestamp = 0
      @fps_limit = 100
      @expose_timestamp = 0
      @pane = nil
      @mouse_in = nil
      ObjectSpace.define_finalizer(self, Window.finalizer(@pointer))
    end

    class << self
      attr_accessor :default_pane

      def finalizer pointer
        proc{ Pastele.window_delete pointer }
      end
    end

    self.default_pane = Pane
    
    attr :pointer

    def attach app
      @app = app
      @update_thread = Thread.new do
        loop do
          Pastele.window_update_request window.pointer
          @update_queue.pop&.then{|it| sleep it }
        end
      end
    end

    def detach
      @app = nil
      @update_thread&.kill
      @update_thread = nil
    end

    def app
      @app
    end

    def update_complete event
      @update_queue << if @fps_limit
        update_delay (event.timestamp - @update_timestamp) / 1000000000.0, 1.0 / @fps_limit
      end
      @update_timestamp = event.timestamp
    end

    def update_delay last, target
      e = 3 * target - 2 * last
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
        else true end
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
      pane&.window&.set_pane nil
      pane&.window = self
      Pastele.window_set_scene @pointer, pane&.pointer
      update_paint pane if pane
      @pane = pane
    end

    def paint_shown pane, direct
      @pane == pane && !!@app
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
        [limit.begin || 0, limit.end || 0]
      else
        [0, limit || 0]
      end
    end
  end
end