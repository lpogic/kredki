module Kredki
  class Window

    def show!
      Pastele.window_show @pointer
    end

    def hide!
      Pastele.window_hide @pointer
    end

    # Maximize a window.
    def maximize!
      Pastele.window_maximize @pointer
    end

    # Minimize a window.
    def minimize!
      Pastele.window_minimize @pointer
    end

    # Request that a window be raised above other windows and gain the input focus.
    def focus!
      Pastele.window_focus @pointer
    end

    # Request that the size and position of a minimized or maximized window be restored.
    def restore!
      Pastele.window_restore @pointer
    end

    # Set whether the window has an outline.
    def outline! value = true
      return if (c = outline) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.window_set_bordered @pointer, value ? 1 : 0
      true
    end

    # See #outline!.
    def outline= value
      outline! value
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
    def fullscreen! value = true
      return if (c = fullscreen) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.window_set_fullscreen @pointer, value ? 1 : 0
      true
    end

    # See #fullscreen!.
    def fullscreen= value
      fullscreen! value
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
    def text_input! value = true
      return if (c = text_input) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.window_set_text_input @pointer, value ? 1 : 0
      true
    end

    # See #text_input!.
    def text_input= value
      text_input! value
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
    def opacity! opacity = @opacity
      return opacity! yield self.opacity if block_given?
      return if @opacity == opacity
      Pastele.window_set_opacity @pointer, opacity > 1 ? opacity / 255.0 : opacity
      @opacity = opacity
      true
    end

    # See #opacity!.
    def opacity= param
      opacity! param
    end

    # Get opacity.
    def opacity
      @opacity
    end

    # Set position along X and Y axes.
    def xy! x = 0, y = x
      return send_ahp :xy!, yield(self.xy) if block_given?
      x = case x
      when Start
        0
      when Center
        (display_wh[0] - wh[0]) * 0.5
      when End
        display_wh[0] - wh[0]
      when Numeric
        x
      else raise_ia x
      end

      y = case y
      when Start
        0
      when Center
        (display_wh[1] - wh[1]) * 0.5
      when End
        display_wh[1] - wh[1]
      when Numeric
        y
      else raise_ia y
      end

      Pastele.window_set_position @pointer, x, y
      true
    end

    # See #xy!.
    def xy= param
      send_ahp :xy!, param
    end
    
    # Get position along X and Y axes.
    def xy
      point = Pastele::IntPoint.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_position @pointer, point
      [point.x, point.y]
    end

    # Set width and height. 
    def wh! w = 400, h = w, **na
      return send_ahp :wh!, yield(self.wh) if block_given?
      w = case w
      when Rational
        display_wh[0] * w
      when Numeric
        w
      else raise_ia w
      end

      h = case h
      when Rational
        display_wh[1] * h
      when Numeric
        h
      else raise_ia h
      end
      
      Pastele.window_set_size @pointer, w, h
      na.each{ send_ahp "wh_#{_1}!", _2 }
      report ResizeEvent.new w, h
      true
    end

    # See #wh!.
    def wh= param
      send_ahp :wh!, param
    end

    # Get width and height.
    def wh
      point = Pastele::IntPoint.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_size @pointer, point
      [point.x, point.y]
    end

    # Set width and height limit. 
    def wh_limit! w, h = w
      return send_ahp :wh_limit!, yield(self.wh_limit) if block_given?
      w_min, w_max = parse_limit w
      h_min, h_max = parse_limit h
      Pastele.window_set_minimum_size @pointer, w_min, h_min
      Pastele.window_set_maximum_size @pointer, w_max, h_max
      true
    end

    # See #wh_limit!.
    def wh_limit= param
      send_ahp :wh_limit!, param
    end

    # Get width and height limit.
    def wh_limit
      point = Pastele::IntPoint.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_minimum_size @pointer, point
      w_min, h_min = [point.x, point.y]
      Pastele.window_get_maximum_size @pointer, point
      [w_min..point.x, h_min..point.y]
    end

    # Set whether a window width and height can be customized by dragging its border.
    def wh_drag! value = true
      return if (c = wh_drag) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.window_set_resizable @pointer, value ? 1 : 0
      true
    end

    # See #wh_drag!.
    def wh_drag= param
      wh_drag! param
    end

    # Get whether a window width and height can be customized by dragging its border.
    def wh_drag
      Pastele.window_get_flags(@pointer) & 0x20 != 0
    end

    # See #wh_drag.
    def wh_drag?
      !!wh_drag
    end

    # Set title.
    def title! title = nil
      return title! yield self.title if block_given?
      Pastele.window_set_title @pointer, title.to_s
      true
    end

    # See #title!.
    def title= param
      title! param
    end

    # Get title.
    def title
      title = Pastele.window_get_title @pointer
      title.to_s.force_encoding "utf-8"
    end

    # Set whether window is always in the foreground.
    def top! value = true
      return if (c = top) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.window_set_always_on_top @pointer, value ? 1 : 0
      true
    end

    # See #top!.
    def top= param
      top! param
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
    def mouse_grab! value = true
      return if (c = mouse_grab) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.window_set_mouse_mouse_grab @pointer, value ? 1 : 0
      true
    end

    # See #mouse_grab!.
    def mouse_grab= value
      mouse_grab! value
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
    def mouse_relative! value = true
      return if (c = relative) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.window_set_mouse_relative_mode @pointer, value ? 1 : 0
      true
    end

    # See #mouse_relative!.
    def mouse_relative= value
      mouse_relative! value
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

    # Set and build current scene.
    def scene! scene = nil, ...
      case scene
      when Class
        scene = scene.new
        set_scene scene
        scene.sketch
        scene.build_context.alter(...)
      when String
        build_context = scene! Window.default_scene
        build_context.alter{ eval File.read scene }.alter(...)
      when nil
        scene!(Window.default_scene, ...)
      else
        set_scene scene
        cene.build_context.alter(...)
      end
    end

    # See #scene!.
    def scene= param
      send_ahp :scene!, param
    end

    # Get current scene.
    def scene
      @scene
    end

    # Get window (self).
    def window
      self
    end

    # Request window close.
    def close
      Pastele.window_close @pointer
    end

    # Get display width and height.
    def display_wh
      bounds = Pastele::Bounds.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_display_bounds @pointer, bounds
      [bounds.w, bounds.h]
    end

    # Set update rate.
    def update_rate! update_rate = @update_rate
      return update_rate! yield(@update_rate) if block_given?
      return if @update_rate == update_rate
      @update_rate = update_rate
      true
    end

    # See #update_rate!.
    def update_rate= param
      send_ahp :update_rate!, param
    end

    # Get update rate.
    def update_rate
      @update_rate
    end

    # Save window as PNG image.
    def to_png filepath
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

    def initialize w = 400, h = 400, engine: :sw
      @pointer = case engine
      when :sw
        @pointer = Pastele.window_new_sw w, h
      # when :gl
      #   @pointer = Pastele.window_new_gl w, h
      else
        raise_ia engine
      end
      @application = nil
      @update_thread = nil
      @update_queue = Thread::Queue.new
      @update_timestamp = 0
      @update_rate = 60
      @scene = nil
      @mouse_in = nil
      ObjectSpace.define_finalizer(self, Window.finalizer(@pointer))
    end

    class << self
      attr_accessor :default_scene
    end

    self.default_scene = WindowScene

    def self.finalizer pointer
      proc{ Pastele.window_delete pointer }
    end
    
    attr :pointer

    def attach! application
      @application = application
      @update_thread = Thread.new do
        loop do
          Pastele.window_update window.pointer
          sleep @update_queue.pop
        end
      end
    end

    def detach!
      @application = nil
      @update_thread&.kill
      @update_thread = nil
    end

    def application
      @application
    end

    def update_complete event
      delay = (event.timestamp - @update_timestamp) / 1000000000.0
      rate_delay = 1.0 / @update_rate
      @update_queue << (delay - rate_delay > rate_delay ? rate_delay : 2 * rate_delay - delay)
      @update_timestamp = event.timestamp
    end

    def report event, ...
      case event
      when UpdateCompleteEvent
        update_complete event
      else
        @scene.report(event, ...)
      end
    end

    def update_paint paint
      Pastele.window_paint_to_update @pointer, paint.pointer
    end

    def inspect
      "#{self.class}:#{object_id}"
    end

    def set_scene scene, &block
      scene.scene = self
      Pastele.window_set_scene @pointer, scene.pointer
      update_paint scene
      @scene = scene
    end

    def paint_shown scene, direct
      @scene == scene && !!@application
    end

    def set_mouse_in set
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